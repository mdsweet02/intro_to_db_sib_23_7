import tkinter as tk
from tkinter import ttk, messagebox, simpledialog
import pyodbc
import pandas as pd
import decimal
import datetime

server = 'localhost'
database = 'Stud_Бектенов_Куаныш'
conn = pyodbc.connect(f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE={database};Trusted_Connection=yes;')
cursor = conn.cursor()

tables_info = {
    'Приемщик': ['КодПриемщика'],
    'Оправы': ['АртикулОправы'],
    'Линзы': ['АртикулЛинзы'],
    'Услуги': ['КодУслуги'],
    'Работники': ['ТабельныйНомер'],
    'Заказ': ['НомерЗаказа'],
    'Заказ_Оправы': [],
    'Заказ_Линзы': [],
    'Заказ_Услуги': [],
    'Касса_Заказ': []
}

class App:
    def __init__(self, master):
        self.master = master
        master.title("Клиентское приложение для БД")
        master.geometry("1000x600")

        self.current_table = None

        menubar = tk.Menu(master)
        master.config(menu=menubar)

        db_menu = tk.Menu(menubar, tearoff=0)
        for table in tables_info.keys():
            db_menu.add_command(label=f"Просмотр таблицы {table}", command=lambda t=table: self.view_table(t))
        db_menu.add_command(label="Добавить запись", command=self.add_record)
        db_menu.add_command(label="Выполнить SQL-запрос", command=self.run_query)
        db_menu.add_command(label="Экспорт текущей таблицы в Excel", command=self.export_excel)
        db_menu.add_separator()
        db_menu.add_command(label="Выход", command=master.quit)
        menubar.add_cascade(label="База данных", menu=db_menu)

        help_menu = tk.Menu(menubar, tearoff=0)
        help_menu.add_command(label="Справка", command=self.show_help)
        menubar.add_cascade(label="Справка", menu=help_menu)

        self.tree = ttk.Treeview(master)
        self.tree.pack(fill=tk.BOTH, expand=True)
        self.tree.bind("<Double-1>", self.edit_cell)

        self.menu = tk.Menu(master, tearoff=0)
        self.menu.add_command(label="Удалить запись", command=self.delete_record)
        self.tree.bind("<Button-3>", self.show_context_menu)

    def view_table(self, table_name):
        self.current_table = table_name
        self.tree.delete(*self.tree.get_children())
        cursor.execute(f"SELECT * FROM dbo.{table_name}")
        rows = cursor.fetchall()
        columns = [column[0] for column in cursor.description]
        self.tree["columns"] = columns
        self.tree["show"] = "headings"
        for col in columns:
            self.tree.heading(col, text=col)

        for row in rows:
            display_row = []
            for val in row:
                if isinstance(val, (float, int, decimal.Decimal)):
                    display_row.append(str(val))
                elif isinstance(val, (datetime.date, datetime.datetime)):
                    display_row.append(val.strftime("%Y-%m-%d"))
                else:
                    display_row.append("" if val is None else str(val))
            self.tree.insert("", tk.END, values=display_row)

    def edit_cell(self, event):
        if not self.current_table:
            return
        item = self.tree.identify('item', event.x, event.y)
        column = self.tree.identify_column(event.x)
        col_index = int(column.replace('#', '')) - 1
        if col_index < 0:
            return

        col_name = self.tree["columns"][col_index]
        if col_name in tables_info[self.current_table]:
            messagebox.showinfo("Редактирование", "Это поле редактировать нельзя!")
            return

        old_value = self.tree.item(item, "values")[col_index]
        new_value = simpledialog.askstring("Редактировать", f"Старое значение: {old_value}\nВведите новое:")
        if new_value is not None:
            row_id = self.tree.item(item, "values")[0]
            try:
                cursor.execute(f"UPDATE dbo.{self.current_table} SET {col_name}=? WHERE {self.tree['columns'][0]}=?", new_value, row_id)
                conn.commit()
                self.view_table(self.current_table)
            except Exception as e:
                messagebox.showerror("Ошибка", str(e))

    def delete_record(self):
        if not self.current_table:
            return
        selected = self.tree.selection()
        if not selected:
            return
        confirm = messagebox.askyesno("Удаление", "Вы действительно хотите удалить запись?")
        if not confirm:
            return
        try:
            for item in selected:
                row_id = self.tree.item(item, "values")[0]
                cursor.execute(f"DELETE FROM dbo.{self.current_table} WHERE {self.tree['columns'][0]}=?", row_id)
            conn.commit()
            self.view_table(self.current_table)
        except Exception as e:
            messagebox.showerror("Ошибка", str(e))

    def show_context_menu(self, event):
        try:
            self.menu.post(event.x_root, event.y_root)
        finally:
            self.menu.grab_release()

    def add_record(self):
        if not self.current_table:
            messagebox.showinfo("Добавление", "Сначала выберите таблицу!")
            return

        columns = [c for c in self.tree["columns"] if c not in tables_info[self.current_table]]
        values = {}
        for col in columns:
            val = simpledialog.askstring("Добавить запись", f"Введите {col}:")
            if val is None:
                return
            values[col] = val

        cols_str = ', '.join(values.keys())
        params_str = ', '.join(['?'] * len(values))
        try:
            cursor.execute(f"INSERT INTO dbo.{self.current_table} ({cols_str}) VALUES ({params_str})", *values.values())
            conn.commit()
            self.view_table(self.current_table)
        except Exception as e:
            messagebox.showerror("Ошибка", str(e))

    def run_query(self):
        query_window = tk.Toplevel(self.master)
        query_window.title("Выполнить SQL-запрос")
        tk.Label(query_window, text="Введите SQL-запрос:").pack()
        query_text = tk.Text(query_window, height=5)
        query_text.pack()
        def execute():
            try:
                query = query_text.get("1.0", tk.END)
                df = pd.read_sql_query(query, conn)
                result_window = tk.Toplevel(self.master)
                result_window.title("Результаты запроса")
                tree = ttk.Treeview(result_window)
                tree.pack(fill=tk.BOTH, expand=True)
                tree["columns"] = list(df.columns)
                tree["show"] = "headings"
                for col in df.columns:
                    tree.heading(col, text=col)
                for index, row in df.iterrows():
                    display_row = []
                    for val in row:
                        if isinstance(val, (float, int, decimal.Decimal)):
                            display_row.append(str(val))
                        elif isinstance(val, (datetime.date, datetime.datetime)):
                            display_row.append(val.strftime("%Y-%m-%d"))
                        else:
                            display_row.append("" if val is None else str(val))
                    tree.insert("", tk.END, values=display_row)
            except Exception as e:
                messagebox.showerror("Ошибка", str(e))
        tk.Button(query_window, text="Выполнить", command=execute).pack()

    def export_excel(self):
        if not self.current_table:
            messagebox.showinfo("Экспорт", "Сначала выберите таблицу!")
            return
        df = pd.read_sql_query(f"SELECT * FROM dbo.{self.current_table}", conn)
        filename = f"{self.current_table}_отчет.xlsx"
        df.to_excel(filename, index=False)
        messagebox.showinfo("Экспорт", f"Таблица экспортирована в файл {filename}")

    def show_help(self):
        messagebox.showinfo("Справка",
            "Приложение позволяет:\n"
            "- Просматривать таблицы базы данных\n"
            "- Добавлять новые записи\n"
            "- Редактировать записи (кроме автоинкрементных полей)\n"
            "- Удалять записи\n"
            "- Выполнять SQL-запросы\n"
            "- Экспортировать таблицы в Excel\n"
            "- Навигировать по данным через интерфейс Treeview"
        )

root = tk.Tk()
app = App(root)
root.mainloop()
