
from PyQt5.QtWidgets import QWidget, QVBoxLayout, QHBoxLayout, QPushButton, QTableWidget, QTableWidgetItem, QMessageBox
import pandas as pd
from dialogs_appointments import AddAppointmentDialog
from utils import get_connection, style_table

def build_appointment_page():
    page = QWidget()
    layout = QVBoxLayout()
    table = QTableWidget()
    style_table(table)
    layout.addWidget(table)

    btns = QHBoxLayout()
    for label, slot in [
        ("➕ Add", lambda: add_appointment(table)),
        ("✏️ Edit", lambda: edit_appointment(table)),
        ("🗑️ Delete", lambda: delete_appointment(table)),
        ("🔁 Refresh", lambda: load_appointments(table))
    ]:
        b = QPushButton(label)
        b.setStyleSheet("font-size: 12pt; padding: 6px;")
        b.clicked.connect(slot)
        btns.addWidget(b)

    layout.addLayout(btns)
    page.setLayout(layout)
    load_appointments(table)
    return page

def load_appointments(table):
    conn = get_connection()
    if conn:
        df = pd.read_sql("SELECT * FROM PatientRegister", conn)
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

def add_appointment(table):
    dlg = AddAppointmentDialog()
    if dlg.exec_():
        load_appointments(table)

def edit_appointment(table):
    selected = get_selected(table)
    if not selected:
        QMessageBox.warning(None, "No Selection", "Select an appointment to edit.")
        return
    dlg = AddAppointmentDialog(selected)
    if dlg.exec_():
        load_appointments(table)

def delete_appointment(table):
    selected = get_selected(table)
    if not selected:
        QMessageBox.warning(None, "No Selection", "Select an appointment to delete.")
        return
    confirm = QMessageBox.question(None, "Confirm Delete",
                                   f"Delete appointment ID {selected['PatientRegisterID']}?",
                                   QMessageBox.Yes | QMessageBox.No)
    if confirm == QMessageBox.Yes:
        conn = get_connection()
        if conn:
            cur = conn.cursor()
            cur.execute("DELETE FROM PatientRegister WHERE PatientRegisterID=%s", (selected['PatientRegisterID'],))
            conn.commit()
            conn.close()
            load_appointments(table)
    