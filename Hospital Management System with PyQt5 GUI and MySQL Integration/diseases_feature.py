from PyQt5.QtWidgets import QWidget, QVBoxLayout, QHBoxLayout, QPushButton, QTableWidget, QTableWidgetItem, QMessageBox
import pandas as pd
from dialogs_disease import AddDiseaseDialog
from utils import get_connection, style_table

def build_disease_page():
    page = QWidget()
    layout = QVBoxLayout()
    table = QTableWidget()
    style_table(table)
    layout.addWidget(table)

    btns = QHBoxLayout()
    for label, slot in [
        ("➕ Add", lambda: add_disease(table)),
        ("✏️ Edit", lambda: edit_disease(table)),
        ("🗑️ Delete", lambda: delete_disease(table)),
        ("🔁 Refresh", lambda: load_diseases(table))
    ]:
        b = QPushButton(label)
        b.setStyleSheet("font-size: 12pt; padding: 6px;")
        b.clicked.connect(slot)
        btns.addWidget(b)

    layout.addLayout(btns)
    page.setLayout(layout)
    load_diseases(table)
    return page

def load_diseases(table):
    conn = get_connection()
    if conn:
        df = pd.read_sql("SELECT * FROM Disease", conn)
        conn.close()
        table.setRowCount(len(df))
        table.setColumnCount(len(df.columns))
        table.setHorizontalHeaderLabels(df.columns)
        for row in range(len(df)):
            for col in range(len(df.columns)):
                table.setItem(row, col, QTableWidgetItem(str(df.iloc[row, col])))

def get_selected(table):
    row = table.currentRow()
    if row < 0:
        return None
    return {
        table.horizontalHeaderItem(c).text(): table.item(row, c).text()
        for c in range(table.columnCount())
    }

def add_disease(table):
    dlg = AddDiseaseDialog()
    if dlg.exec_():
        load_diseases(table)

def edit_disease(table):
    selected = get_selected(table)
    if not selected:
        QMessageBox.warning(None, "No Selection", "Select a disease to edit.")
        return
    dlg = AddDiseaseDialog(selected)
    if dlg.exec_():
        load_diseases(table)

def delete_disease(table):
    selected = get_selected(table)
    if not selected:
        QMessageBox.warning(None, "No Selection", "Select a disease to delete.")
        return
    confirm = QMessageBox.question(None, "Confirm Delete",
                                   f"Delete disease '{selected['Name']}'?",
                                   QMessageBox.Yes | QMessageBox.No)
    if confirm == QMessageBox.Yes:
        conn = get_connection()
        if conn:
            cur = conn.cursor()
            cur.execute("DELETE FROM Disease WHERE DiseaseID=%s", (selected['DiseaseID'],))
            conn.commit()
            conn.close()
            load_diseases(table)