
import tkinter as tk
from tkinter import ttk, messagebox
import pyodbc

def get_connection():
    try:
        conn = pyodbc.connect(
            "Driver={SQL Server};"
            "Server=WIN-GCIS8AGEN8D\SQLEXPRESS;"
            "Database=Фонотека;"
            "Trusted_Connection=yes;"
        )
        return conn
    except Exception as e:
        messagebox.showerror("Ошибка подключения", str(e))
        return None


def update_single_column(title, values):
    table.heading("col", text=title)  

    table.delete(*table.get_children())
    for val in values:
        table.insert("", "end", values=[val])

    max_len = max((len(str(v)) for v in values), default=20)
    table.column("col", width=max_len * 10)


def show_disks_by_category():
    category = entry_category.get()

    if category == "":
        messagebox.showwarning("Ошибка", "Введите категорию!")
        return

    conn = get_connection()
    if not conn:
        return
    cursor = conn.cursor()

    query = """
    SELECT D.Наименование
    FROM Диск D
    JOIN КатегорииДисков K
      ON D.КодКатегорииДиска = K.КодКатегорииДиска
    WHERE K.Наименование = ?
"""

    cursor.execute(query, category)
    rows = cursor.fetchall()
    conn.close()

    if not rows:
        messagebox.showinfo("Результат", "Нет дисков в этой категории")
        table.delete(*table.get_children())
        return

    values = [r[0] for r in rows]
    update_single_column("Диски", values)

def show_artists():
    conn = get_connection()
    if not conn:
        return
    cursor = conn.cursor()

    cursor.execute("SELECT ФИО_или_Наименование FROM Исполнители")
    rows = cursor.fetchall()
    conn.close()

    values = [r[0] for r in rows]
    update_single_column("Исполнители", values)

def show_price_by_disk_name():
    name = entry_disk_name.get()

    if name == "":
        messagebox.showwarning("Ошибка", "Введите название диска!")
        return

    conn = get_connection()
    if not conn:
        return
    cursor = conn.cursor()

    cursor.execute("SELECT ЦенаЗалоговая FROM Диск WHERE Наименование = ?", name)
    row = cursor.fetchone()
    conn.close()

    if not row:
        messagebox.showinfo("Ошибка", "Такой диск не найден")
        table.delete(*table.get_children())
        return

    value = f"{name} — {row[0]} тг"
    update_single_column("Цена диска", [value])

root = tk.Tk()
root.title("Фонотека — клиент")
root.geometry("700x500")

tk.Label(root, text="Категория:").grid(row=0, column=0, padx=5, pady=5)
entry_category = tk.Entry(root, width=30)
entry_category.grid(row=0, column=1)

tk.Label(root, text="Название диска:").grid(row=1, column=0, padx=5, pady=5)
entry_disk_name = tk.Entry(root, width=30)
entry_disk_name.grid(row=1, column=1)

tk.Button(root, text="Показать диски по категории",
          width=30, command=show_disks_by_category).grid(row=0, column=2, padx=10)

tk.Button(root, text="Показать всех исполнителей",
          width=30, command=show_artists).grid(row=1, column=2, padx=10)

tk.Button(root, text="Показать цену диска",
          width=30, command=show_price_by_disk_name).grid(row=2, column=2, padx=10)

table = ttk.Treeview(root, columns=("col",), show="headings", height=18)
table.heading("col", text="Данные")
table.column("col", width=300)
table.grid(row=3, column=0, columnspan=4, padx=10, pady=20)

root.mainloop()
