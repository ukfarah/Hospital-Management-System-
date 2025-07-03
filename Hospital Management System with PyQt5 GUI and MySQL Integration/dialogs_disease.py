from PyQt5.QtWidgets import QDialog, QFormLayout, QLineEdit, QComboBox, QPushButton, QMessageBox
from utils import get_connection

class AddDiseaseDialog(QDialog):
    def __init__(self, disease=None):
        super().__init__()
        self.setWindowTitle("Add / Edit Disease")
        self.setMinimumWidth(400)
        layout = QFormLayout()

        self.fields = {
            'DiseaseID': QLineEdit(),
            'Name': QLineEdit(),
            'Description': QLineEdit(),
            'Severity': QComboBox(),
            'Symptoms': QLineEdit(),
            'Complications': QLineEdit(),
            'Treatment': QLineEdit()
        }

        self.fields['Severity'].addItems(['Mild', 'Moderate', 'Severe'])

        for label, widget in self.fields.items():
            layout.addRow(label + ":", widget)

        if disease:
            for key, widget in self.fields.items():
                if isinstance(widget, QComboBox):
                    index = widget.findText(disease[key])
                    if index >= 0:
                        widget.setCurrentIndex(index)
                else:
                    widget.setText(str(disease[key]))
            self.fields['DiseaseID'].setReadOnly(True)

        save_btn = QPushButton("Save")
        save_btn.clicked.connect(self.save_disease)
        layout.addRow(save_btn)
        self.setLayout(layout)

    def save_disease(self):
        values = {key: (widget.currentText() if isinstance(widget, QComboBox) else widget.text().strip())
                  for key, widget in self.fields.items()}

        if any(v == '' for k, v in values.items() if k != 'DiseaseID' or not self.fields[k].isReadOnly()):
            QMessageBox.warning(self, "Validation Error", "All fields must be filled.")
            return

        conn = get_connection()
        if conn:
            cur = conn.cursor()
            if self.fields['DiseaseID'].isReadOnly():
                sql = """
                    UPDATE Disease SET Name=%s, Description=%s, Severity=%s, Symptoms=%s, Complications=%s, Treatment=%s
                    WHERE DiseaseID=%s
                """
                params = tuple(values[k] for k in list(values.keys())[1:]) + (values['DiseaseID'],)
            else:
                sql = """
                    INSERT INTO Disease (DiseaseID, Name, Description, Severity, Symptoms, Complications, Treatment)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                """
                params = tuple(values.values())

            try:
                cur.execute(sql, params)
                conn.commit()
                QMessageBox.information(self, "Success", "Disease saved successfully.")
                self.accept()
            except Exception as e:
                QMessageBox.critical(self, "Database Error", str(e))
            finally:
                conn.close()