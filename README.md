# 🏷 Grade Report – Bash Project

A Bash script that reads student grades from a CSV file, calculates averages, assigns mentions, ranks students, and displays the class average.

## 📌 Problem Statement

Manual calculation of student grades is time-consuming and can lead to errors. This project automates the process.

## 🎯 Project Goals

- Calculate student averages.
- Assign academic mentions.
- Rank students by performance.
- Calculate class average.
- Detect invalid records.

## 🛠 Tech Stack

- Bash
- AWK
- Linux
- Git & GitHub

## 🖥 Features

- CSV processing.
- Automatic grade calculation.
- Student ranking.
- Input validation.
- Formatted reports using printf.
- Error handling.

## 📷 Screenshots

![alt text](<asset/images/Screenshot From 2026-11-02 13-41-18.png>)
![alt text](<asset/images/Screenshot From 2026-11-02 13-42-08.png>)

## ⚙️ Installation & Setup

## Files

- `grades.sh` – Main script that generates the grade report.
- `grades.csv` – Sample CSV file containing student names and grades.
- `messy.csv` – Test CSV file containing invalid records and extra spaces to test error handling.

## How to Run

```bash
git clone https://github.com/Mecaly-kjr/bash-09-grade-report.git

cd bash-09-grade-report

```

```bash
chmod +x grades.sh
```

Run the script with the sample CSV file:

```bash
./grades.sh grades.csv
```

You can also test it with:

```bash
./grades.sh messy.csv
```

## Requirements

- Bash
- CSV file with the header: `name,html,css,bash,git`

The script skips invalid records and displays warnings with their line numbers.

## 🧠 Challenges Faced

- Processing CSV files.
- Validating scores.
- Sorting students.
- Handling extra spaces and Windows line endings.

## 📚 What I Learned

- Bash scripting.
- AWK calculations.
- Linux commands.
- Git and GitHub.

## 🚀 Future Improvements

- Export reports to PDF.
- Support more subjects.
- Add automated tests.

## 👨🏽‍💻 Author

Mecaly Luther Bobbilla

[mecalyluther64@gmail.com](mailto:mecalyluther64@gmail.com)

Junior Developer | Software Engineering

Based in Cameroon.
