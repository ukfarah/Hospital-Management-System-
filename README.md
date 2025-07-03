# 🏥 Hospital Management System with PyQt5 GUI and MySQL Integration

Welcome to the **Hospital Management System** – a fully-featured, modern, and intuitive desktop application built using **Python (PyQt5)** and **MySQL**. This system aims to digitalize and simplify hospital management tasks like patient records, doctor profiles, appointment scheduling, disease diagnosis, lab reporting, and insurance information.

Whether you're a hospital administrator, medical records officer, or a developer exploring healthcare software solutions, this project provides a real-world example of how GUI and database technologies can work together efficiently.

---

## 📸 User Interface Preview

The following screenshots demonstrate different parts of the system interface. All images are centered and designed with a focus on clarity and usability.

<p align="center">
  <img src="![image](https://github.com/user-attachments/assets/1153282b-df6a-4889-b999-d5c037cd2ead)" width="600" alt="Dashboard Screenshot"/>
  <br><em>Centralized dashboard overview</em>
</p>

<p align="center">
  <img src="![image](https://github.com/user-attachments/assets/f5c6f99a-08bd-4198-ac38-a1c2be1e93c5)" width="600" alt="Add Patient Screenshot"/>
  <br><em>Patient registration form</em>
</p>

<p align="center">
  <img src="![image](https://github.com/user-attachments/assets/7b353da3-cc6a-4645-ab53-509b9aa150f2)" width="600" alt="Doctor List Screenshot"/>
  <br><em>Doctors management screen</em>
</p>

<p align="center">
  <img src="![image](https://github.com/user-attachments/assets/c7d58360-2e0b-44bd-93c2-e5e795a4ec85)" width="600" alt="Appointment Screenshot"/>
  <br><em>Appointment scheduler and viewer</em>
</p>

<p align="center">
  <img src="![image](https://github.com/user-attachments/assets/5777b807-5a77-4b86-8083-a98b14887013)" width="600" alt="Lab Reports Screenshot"/>
  <br><em>Lab test results and upload</em>
</p>

<p align="center">
  <img src="![image](https://github.com/user-attachments/assets/77428d91-c21c-44e4-81cc-f6d1d670100b)" width="600" alt="Insurance Screenshot"/>
  <br><em>Insurance policy data and claims</em>
</p>

---

## 🌟 Key Features

- **🧍 Patient Management** – Add, edit, delete, and view detailed patient profiles.
- **👨‍⚕️ Doctor Profiles** – Track doctor names, specialties, availability, and more.
- **📅 Appointments Module** – Book and manage appointments with date/time slots.
- **🧪 Lab Reports System** – Upload and access diagnostic reports for patients.
- **🦠 Disease Tracking** – Record and monitor patient disease history.
- **🛡️ Insurance Module** – Store and retrieve patient insurance information.
- **🔐 Secure Login System** – Admin authentication using credential verification.
- **📦 MySQL Integration** – All data operations are backed by a relational DB.
- **📊 Organized GUI** – Built with PyQt5, ensuring usability and responsiveness.

---

## 🧠 Who Is This For?

This system is ideal for:
- Small to medium-sized clinics and hospitals.
- Developers learning PyQt5 and database integration.
- IT professionals seeking healthcare management tools.
- Academic and portfolio project purposes.

---

## 🧰 Technologies & Tools Used

| Technology       | Purpose                         |
|------------------|----------------------------------|
| **Python 3.x**   | Programming language             |
| **PyQt5**        | GUI Framework                    |
| **MySQL**        | Backend database                 |
| **mysql-connector-python** | Python to MySQL bridge     |
| **Qt Designer**  | GUI visual layout (optional)     |
| **Git/GitHub**   | Version control and collaboration|

---

## 📁 Project Folder Structure

```bash
Hospital-Management-System/
├── main.py                         # Main launcher file
├── hospital_app.py                 # Core GUI logic
├── config.py                       # MySQL DB configurations
├── dialogs.py                      # All user interface dialogs
├── appointments_feature.py         # Appointment logic
├── diseases_feature.py             # Disease management
├── insurance_feature.py            # Insurance data features
├── lab_reports_feature.py          # Upload/view lab reports
├── utils.py                        # Reusable utility functions
├── HospitalManagementSystemDATABASE.sql  # DB schema setup
├── README.md                       # Project documentation
└── images/                         # 📸 Your 6 GUI screenshots go here

```


A comprehensive desktop application for managing hospital operations, built with Python and PyQt5, with MySQL database integration.

![App Screenshot](images/screenshot1.png) <!-- Replace with your actual image file -->

## ⚙️ Installation Guide

### 🖥️ 1. Clone the Repository
```bash
git clone https://github.com/yourusername/hospital-management-system.git
cd hospital-management-system
```

### 🧪  2. Set Up Virtual Environment (Optional)
```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
```

### 📦  3. Install Python Dependencies
```bash
pip install pyqt5 mysql-connector-python

```

### 🗄️  4. Set Up MySQL Database

1. Open MySQL Workbench or your preferred DB tool.

2. Create a new schema (e.g., hospital_db).

3. Execute HospitalManagementSystemDATABASE.sql to set up tables and initial structure.


### 🗄️  5. Run the Application
```bash
python main.py
```


## 🧪 How to Use the System

1. **Log in** with your admin credentials (stored in the database).
2. Use the top menu to navigate between the modules:
   - 🧍 **Patients**
   - 👨‍⚕️ **Doctors**
   - 📅 **Appointments**
   - 🧪 **Reports**
   - 🦠 **Diseases**
   - 🛡️ **Insurance**
3. Add, edit, or remove records as needed.
4. All changes are reflected in **real-time** in the MySQL database.

---

## 💡 Future Improvements (Ideas)

- 📱 Convert to a **cross-platform** web app using **Flask** or **Django**
- 🧑‍🤝‍🧑 Add multiple user roles: **doctor**, **receptionist**, **admin**
- 🧾 Generate **PDF reports** for patients
- 📬 Implement **email/SMS notifications** for upcoming appointments
- 🌐 Use **cloud-hosted MySQL** to enable remote access

---

## 🤝 Contributions

Pull requests are welcome! If you'd like to improve or fix something, feel free to:

1. **Fork** the repository
2. **Create** a new branch
3. **Commit** your changes
4. **Open** a pull request with a detailed description

Please ensure your code:
- Follows **best practices**
- Is **clean and tested**
- Includes helpful comments when necessary

---

## 📄 License

This project is licensed under the **MIT License**.  
You are free to **use, modify, and distribute** it for personal or commercial purposes with proper **attribution**.

---

## 👨‍💻 Author

****Farah Mohamed***  

---

