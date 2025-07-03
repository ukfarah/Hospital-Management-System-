from PyQt5.QtWidgets import QWidget, QVBoxLayout, QHBoxLayout, QPushButton, QTableWidget, QTableWidgetItem, QMessageBox
import pandas as pd
from utils import get_connection, style_table

def build_insurance_page():
    page = QWidget()
    layout = QVBoxLayout()
    table = QTableWidget()
    style_table(table)
    layout.addWidget(table)

    btns = QHBoxLayout()
    for label, slot in [
        ("🔁 Refresh", lambda: load_insurances(table)),
        ("🗑️ Delete", lambda: delete_insurance(table))
    ]:
        b = QPushButton(label)
        b.setStyleSheet("font-size: 12pt; padding: 6px;")
        b.clicked.connect(slot)
        btns.addWidget(b)

    layout.addLayout(btns)
    page.setLayout(layout)
    load_insurances(table)
    return page

def load_insurances(table):
    conn = get_connection()
    if conn:
        df = pd.read_sql("SELECT * FROM PatientInsurance", conn)
        conn.close()
        table.setRowCount(len(df))
        table.setColumnCount(len(df.columns))
        table.setHorizontalHeaderLabels(df.columns)
        for row in range(len(df)):
            for col in range(len(df.columns)):
                table.setItem(row, col, QTableWidgetItem(str(df.iloc[row, col])))

def delete_insurance(table):
    row = table.currentRow()
    if row < 0:
        QMessageBox.warning(None, "No Selection", "Select an insurance to delete.")
        return
    insurance_id = table.item(row, 0).text()
    confirm = QMessageBox.question(None, "Confirm Delete",
                                   f"Delete insurance ID {insurance_id}?",
                                   QMessageBox.Yes | QMessageBox.No)
    if confirm == QMessageBox.Yes:
        conn = get_connection()
        if conn:
            cur = conn.cursor()
            cur.execute("DELETE FROM PatientInsurance WHERE PatientInsuranceID=%s", (insurance_id,))
            conn.commit()
            conn.close()
            load_insurances(table)