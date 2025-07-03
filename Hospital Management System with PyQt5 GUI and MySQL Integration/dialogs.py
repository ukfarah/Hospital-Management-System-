from PyQt5.QtWidgets import QDialog, QFormLayout, QLineEdit, QComboBox, QPushButton, QMessageBox
from utils import get_connection

# --------------------- Add Patient Dialog ---------------------
class AddPatientDialog(QDialog):
    def __init__(self, patient=None):
        super().__init__()
        self.setWindowTitle("Add / Edit Patient")
        self.setMinimumWidth(400)
        layout = QFormLayout()

        self.fields = {
            'PatientRegNo': QLineEdit(),
            'FirstName': QLineEdit(),
            'LastName': QLineEdit(),
            'Gender': QComboBox(),
            'DateOfBirth': QLineEdit(),
            'PhoneNumber': QLineEdit(),
            'Address': QLineEdit()
        }

        self.fields['Gender'].addItems(['Male', 'Female', 'Other'])

        for label, widget in self.fields.items():
            layout.addRow(label + ":", widget)

        if patient:
            for key, widget in self.fields.items():
                if isinstance(widget, QComboBox):
                    index = widget.findText(str(patient.get(key, "")))
                    if index >= 0:
                        widget.setCurrentIndex(index)
                else:
                    widget.setText(str(patient.get(key, "")))
            self.fields['PatientRegNo'].setReadOnly(True)

        save_btn = QPushButton("Save")
        save_btn.clicked.connect(self.save_patient)
        layout.addRow(save_btn)
        self.setLayout(layout)

    def save_patient(self):
        values = {key: widget.text().strip() if not isinstance(widget, QComboBox) else widget.currentText()
                  for key, widget in self.fields.items()}
        if any(v == '' for k, v in values.items() if k != 'PatientRegNo' or not self.fields[k].isReadOnly()):
            QMessageBox.warning(self, "Validation Error", "All fields must be filled.")
            return

        conn = get_connection()
        if conn:
            cur = conn.cursor()
            if self.fields['PatientRegNo'].isReadOnly():
                sql = """
                    UPDATE Patient SET FirstName=%s, LastName=%s, Gender=%s, DateOfBirth=%s,
                    PhoneNumber=%s, Address=%s WHERE PatientRegNo=%s
                """
                params = tuple(values[k] for k in list(values.keys())[1:]) + (values['PatientRegNo'],)
            else:
                sql = """
                    INSERT INTO Patient (PatientRegNo, FirstName, LastName, Gender, DateOfBirth,
                    PhoneNumber, Address) VALUES (%s, %s, %s, %s, %s, %s, %s)
                """
                params = tuple(values.values())

            try:
                cur.execute(sql, params)
                conn.commit()
                QMessageBox.information(self, "Success", "Patient saved successfully.")
                self.accept()
            except Exception as e:
                QMessageBox.critical(self, "Database Error", str(e))
            finally:
                conn.close()

# --------------------- Add Employee Dialog ---------------------
class AddEmployeeDialog(QDialog):
    def __init__(self, employee=None):
        super().__init__()
        self.setWindowTitle("Add / Edit Employee")
        self.setMinimumWidth(400)
        layout = QFormLayout()

        self.fields = {
            'EmployeeID': QLineEdit(),
            'FirstName': QLineEdit(),
            'LastName': QLineEdit(),
            'Gender': QComboBox(),
            'PhoneNumber': QLineEdit(),
            'RoleID': QComboBox(),
            'Address': QLineEdit(),
            'NationalID': QLineEdit(),
            'DateOfBirth': QLineEdit(),
            'DateOfJoining': QLineEdit(),
            'Salary': QLineEdit()
        }

        self.fields['Gender'].addItems(['Male', 'Female', 'Other'])
        conn = get_connection()
        if conn:
            cur = conn.cursor()
            cur.execute("SELECT RoleID, RoleDesc FROM Role")
            self.roles = cur.fetchall()
            for r in self.roles:
                self.fields['RoleID'].addItem(f"{r[1]} (ID: {r[0]})", r[0])
            conn.close()

        for label, widget in self.fields.items():
            layout.addRow(label + ":", widget)

        if employee:
            for key in self.fields:
                val = employee.get(key, "")
                if isinstance(self.fields[key], QComboBox):
                    index = self.fields[key].findData(int(val)) if key == 'RoleID' else self.fields[key].findText(val)
                    if index >= 0:
                        self.fields[key].setCurrentIndex(index)
                else:
                    self.fields[key].setText(str(val))
            self.fields['EmployeeID'].setReadOnly(True)

        save_btn = QPushButton("Save")
        save_btn.clicked.connect(self.save_employee)
        layout.addRow(save_btn)
        self.setLayout(layout)

    def save_employee(self):
        values = {
            key: (widget.currentData() if key == 'RoleID' else widget.currentText() if isinstance(widget, QComboBox) else widget.text().strip())
            for key, widget in self.fields.items()
        }

        if any(v == '' for k, v in values.items() if k != 'EmployeeID' or not self.fields[k].isReadOnly()):
            QMessageBox.warning(self, "Validation Error", "All fields must be filled.")
            return

        conn = get_connection()
        if conn:
            cur = conn.cursor()
            if self.fields['EmployeeID'].isReadOnly():
                sql = """
                    UPDATE EmployeeDetails SET FirstName=%s, LastName=%s, Gender=%s, PhoneNumber=%s, RoleID=%s,
                    Address=%s, NationalID=%s, DateOfBirth=%s, DateOfJoining=%s, Salary=%s
                    WHERE EmployeeID=%s
                """
                params = tuple(values[k] for k in list(values.keys())[1:]) + (values['EmployeeID'],)
            else:
                sql = """
                    INSERT INTO EmployeeDetails (EmployeeID, FirstName, LastName, Gender, PhoneNumber, RoleID,
                    Address, NationalID, DateOfBirth, DateOfJoining, Salary)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """
                params = tuple(values[k] for k in list(values.keys()))

            try:
                cur.execute(sql, params)
                conn.commit()
                QMessageBox.information(self, "Success", "Employee saved successfully.")
                self.accept()
            except Exception as e:
                QMessageBox.critical(self, "Database Error", str(e))
            finally:
                conn.close()
