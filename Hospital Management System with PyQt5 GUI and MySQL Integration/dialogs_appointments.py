
from PyQt5.QtWidgets import QDialog, QFormLayout, QLineEdit, QPushButton, QMessageBox
from utils import get_connection

class AddAppointmentDialog(QDialog):
    def __init__(self, appointment=None):
        super().__init__()
        self.setWindowTitle("Add / Edit Appointment")
        self.setMinimumWidth(400)
        layout = QFormLayout()

        self.fields = {
            'PatientRegisterID': QLineEdit(),
            'PatientID': QLineEdit(),
            'AdmittedON': QLineEdit(),
            'DischargeON': QLineEdit(),
            'PatientInsuranceID': QLineEdit(),
            'RoomNumber': QLineEdit(),
            'CopayType': QLineEdit(),
            'CreatedBy': QLineEdit()
        }

        for label, widget in self.fields.items():
            layout.addRow(label + ":", widget)

        if appointment:
            for key, widget in self.fields.items():
                widget.setText(str(appointment.get(key, "")))
            self.fields['PatientRegisterID'].setReadOnly(True)

        save_btn = QPushButton("Save")
        save_btn.clicked.connect(self.save_appointment)
        layout.addRow(save_btn)
        self.setLayout(layout)

    def save_appointment(self):
        values = {key: widget.text().strip() for key, widget in self.fields.items()}
        if any(v == '' for k, v in values.items() if k != 'PatientRegisterID' or not self.fields[k].isReadOnly()):
            QMessageBox.warning(self, "Validation Error", "All fields must be filled.")
            return

        conn = get_connection()
        if conn:
            cur = conn.cursor()
            if self.fields['PatientRegisterID'].isReadOnly():
                sql = '''
                    UPDATE PatientRegister SET PatientID=%s, AdmittedON=%s, DischargeON=%s, PatientInsuranceID=%s,
                    RoomNumber=%s, CopayType=%s, CreatedBy=%s WHERE PatientRegisterID=%s
                '''
                params = tuple(values[k] for k in list(values.keys())[1:]) + (values['PatientRegisterID'],)
            else:
                sql = '''
                    INSERT INTO PatientRegister (PatientRegisterID, PatientID, AdmittedON, DischargeON,
                    PatientInsuranceID, RoomNumber, CopayType, CreatedBy)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                '''
                params = tuple(values[k] for k in list(values.keys()))

            try:
                cur.execute(sql, params)
                conn.commit()
                QMessageBox.information(self, "Success", "Appointment saved successfully.")
                self.accept()
            except Exception as e:
                QMessageBox.critical(self, "Database Error", str(e))
            finally:
                conn.close()
    