from diseases_feature import build_disease_page
from insurance_feature import build_insurance_page
from appointments_feature import build_appointment_page
import pandas as pd
from PyQt5.QtWidgets import (
    QWidget, QVBoxLayout, QHBoxLayout, QTableWidget, QPushButton, QLabel,
    QStackedWidget, QListWidget, QTableWidgetItem, QMessageBox, QFrame
)
from PyQt5.QtGui import QFont
from dialogs import AddPatientDialog, AddEmployeeDialog
from utils import get_connection, style_table

class HospitalSystem(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("🏥 Hospital Management System")
        self.setGeometry(100, 100, 1400, 800)
        layout = QHBoxLayout()
        self.menu = QListWidget()
        self.menu.setStyleSheet("font-size: 14pt; background-color: #cce6ff;")
        self.menu.addItems(["Dashboard", "Patients", "Employees", "Diseases", "Insurance", "Appointments"])
        self.menu.setFixedWidth(220)
        self.menu.currentRowChanged.connect(self.switch_page)

        self.stack = QStackedWidget()
        self.stack.addWidget(self.dashboard_page())
        self.stack.addWidget(self.patient_page())
        self.stack.addWidget(self.employee_page())
        self.stack.addWidget(build_disease_page())
        self.stack.addWidget(build_insurance_page())
        self.stack.addWidget(build_appointment_page())

        layout.addWidget(self.menu)
        layout.addWidget(self.stack)
        self.setLayout(layout)

    def switch_page(self, index):
        self.stack.setCurrentIndex(index)

    def dashboard_page(self):
        page = QWidget()
        layout = QVBoxLayout()
        label = QLabel("📊 Hospital Dashboard")
        label.setFont(QFont("Arial", 22))
        label.setStyleSheet("padding: 10px; color: navy;")
        layout.addWidget(label)

        stats_layout = QHBoxLayout()
        conn = get_connection()
        if conn:
            cursor = conn.cursor()
            cursor.execute("SELECT COUNT(*) FROM Patient")
            patients = cursor.fetchone()[0]
            cursor.execute("SELECT COUNT(*) FROM EmployeeDetails")
            employees = cursor.fetchone()[0]
            conn.close()

            stats_layout.addWidget(self.make_info_card("👥 Patients", patients, "#4CAF50"))
            stats_layout.addWidget(self.make_info_card("🧑‍⚕️ Employees", employees, "#2196F3"))

        layout.addLayout(stats_layout)
        page.setLayout(layout)
        return page

    def make_info_card(self, title, count, color):
        card = QFrame()
        card.setStyleSheet(f"background-color: {color}; border-radius: 15px; padding: 25px; margin: 10px; color: white;")
        layout = QVBoxLayout()
        label1 = QLabel(title)
        label1.setStyleSheet("font-size: 18pt;")
        label2 = QLabel(str(count))
        label2.setStyleSheet("font-size: 28pt; font-weight: bold;")
        layout.addWidget(label1)
        layout.addWidget(label2)
        card.setLayout(layout)
        return card

    def patient_page(self):
        page = QWidget()
        layout = QVBoxLayout()
        self.patient_table = QTableWidget()
        style_table(self.patient_table)
        layout.addWidget(self.patient_table)

        btns = QHBoxLayout()
        for label, slot in [("➕ Add", self.add_patient), ("✏️ Edit", self.edit_patient),
                            ("🗑️ Delete", self.delete_patient), ("🔁 Refresh", self.load_patients)]:
            b = QPushButton(label)
            b.setStyleSheet("font-size: 12pt; padding: 6px;")
            b.clicked.connect(slot)
            btns.addWidget(b)

        layout.addLayout(btns)
        page.setLayout(layout)
        self.load_patients()
        return page

    def load_patients(self):
        conn = get_connection()
        if conn:
            df = pd.read_sql("SELECT * FROM Patient", conn)
            conn.close()
            self.patient_table.setRowCount(len(df))
            self.patient_table.setColumnCount(len(df.columns))
            self.patient_table.setHorizontalHeaderLabels(df.columns)
            for row in range(len(df)):
                for col in range(len(df.columns)):
                    self.patient_table.setItem(row, col, QTableWidgetItem(str(df.iloc[row, col])))

    def get_selected_patient(self):
        row = self.patient_table.currentRow()
        if row < 0:
            return None
        return {
            self.patient_table.horizontalHeaderItem(c).text(): self.patient_table.item(row, c).text()
            for c in range(self.patient_table.columnCount())
        }

    def add_patient(self):
        dlg = AddPatientDialog()
        if dlg.exec_():
            self.load_patients()

    def edit_patient(self):
        patient = self.get_selected_patient()
        if not patient:
            QMessageBox.warning(self, "No Selection", "Please select a patient to edit.")
            return
        dlg = AddPatientDialog(patient)
        if dlg.exec_():
            self.load_patients()

    def delete_patient(self):
        patient = self.get_selected_patient()
        if not patient:
            QMessageBox.warning(self, "No Selection", "Please select a patient to delete.")
            return
        confirm = QMessageBox.question(self, "Confirm Delete",
                                       f"Are you sure you want to delete {patient['FirstName']}?",
                                       QMessageBox.Yes | QMessageBox.No)
        if confirm == QMessageBox.Yes:
            conn = get_connection()
            if conn:
                cur = conn.cursor()
                cur.execute("DELETE FROM Patient WHERE PatientRegNo=%s", (patient['PatientRegNo'],))
                conn.commit()
                conn.close()
                self.load_patients()

    def employee_page(self):
        page = QWidget()
        layout = QVBoxLayout()
        self.employee_table = QTableWidget()
        style_table(self.employee_table)
        layout.addWidget(self.employee_table)

        btns = QHBoxLayout()
        for label, slot in [("➕ Add", self.add_employee), ("✏️ Edit", self.edit_employee),
                            ("🗑️ Delete", self.delete_employee), ("🔁 Refresh", self.load_employees)]:
            b = QPushButton(label)
            b.setStyleSheet("font-size: 12pt; padding: 6px;")
            b.clicked.connect(slot)
            btns.addWidget(b)

        layout.addLayout(btns)
        page.setLayout(layout)
        self.load_employees()
        return page

    def load_employees(self):
        conn = get_connection()
        if conn:
            df = pd.read_sql("SELECT * FROM EmployeeDetails", conn)
            conn.close()
            self.employee_table.setRowCount(len(df))
            self.employee_table.setColumnCount(len(df.columns))
            self.employee_table.setHorizontalHeaderLabels(df.columns)
            for row in range(len(df)):
                for col in range(len(df.columns)):
                    self.employee_table.setItem(row, col, QTableWidgetItem(str(df.iloc[row, col])))

    def get_selected_employee(self):
        row = self.employee_table.currentRow()
        if row < 0:
            return None
        return {
            self.employee_table.horizontalHeaderItem(c).text(): self.employee_table.item(row, c).text()
            for c in range(self.employee_table.columnCount())
        }

    def add_employee(self):
        dlg = AddEmployeeDialog()
        if dlg.exec_():
            self.load_employees()

    def edit_employee(self):
        emp = self.get_selected_employee()
        if not emp:
            QMessageBox.warning(self, "No Selection", "Please select an employee to edit.")
            return
        dlg = AddEmployeeDialog(emp)
        if dlg.exec_():
            self.load_employees()

    def delete_employee(self):
        emp = self.get_selected_employee()
        if not emp:
            QMessageBox.warning(self, "No Selection", "Please select an employee to delete.")
            return
        confirm = QMessageBox.question(self, "Confirm Delete",
                                       f"Are you sure you want to delete {emp['FirstName']}?",
                                       QMessageBox.Yes | QMessageBox.No)
        if confirm == QMessageBox.Yes:
            conn = get_connection()
            if conn:
                cur = conn.cursor()
                cur.execute("DELETE FROM EmployeeDetails WHERE EmployeeID=%s", (emp['EmployeeID'],))
                conn.commit()
                conn.close()
                self.load_employees()