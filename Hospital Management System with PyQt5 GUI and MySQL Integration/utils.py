import pymysql
from PyQt5.QtWidgets import QHeaderView

from config import MYSQL_CONFIG

def get_connection():
    try:
        return pymysql.connect(**MYSQL_CONFIG)
    except Exception as e:
        print("Connection Error:", e)
        return None

def style_table(table):
    table.setAlternatingRowColors(True)
    table.setStyleSheet("""
        QTableWidget {
            background-color: #f4faff;
            alternate-background-color: #e6f2ff;
            border: none;
            font-size: 12pt;
        }
        QHeaderView::section {
            background-color: #006699;
            color: white;
            font-weight: bold;
            height: 30px;
        }
    """)
    table.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)