import sys
from PyQt5.QtWidgets import QApplication
from hospital_app import HospitalSystem


if __name__ == '__main__':
    app = QApplication(sys.argv)
    win = HospitalSystem()
    win.show()
    sys.exit(app.exec_())