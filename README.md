# CSV Student Transition Processor (Proof-of-Concept)

## 📚 Project Overview

This Ruby on Rails application demonstrates a **background processing system** for:
- Validating CSV uploads containing family (parent) and student information.
- Handling **Year 2** student transitions (grade updates, family updates).
- Generating **Error Reports** for validation issues.
- Generating **Completed Reports** for successful uploads.
- Ensuring **full transactional safety** — no partial saves.
- Running all heavy processing **in the background using Sidekiq**.

This proof-of-concept focuses on **data integrity**, **background scalability**, and **user feedback** during CSV processing.

---

## ⚙️ Tech Stack

- **Ruby on Rails 7+**
- **PostgreSQL** (primary database)
- **Redis** (required for Sidekiq background jobs)
- **Sidekiq** (for background processing)
- **ActiveStorage** (for file uploads and reports)

---

## 📥 Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone <your-repo-url>
   cd csv_transition_demo
   ```

2. **Install Dependencies**
   ```bash
   bundle install
   yarn install
   ```

3. **Configure Database**
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed
   ```

4. **Start Redis Server**
   ```bash
   # Ubuntu / Linux
   sudo systemctl start redis

   # macOS (if using brew)
   brew services start redis
   ```

5. **Start Rails Server and Sidekiq**
   In one terminal:
   ```bash
   bin/rails server
   ```

   In another terminal:
   ```bash
   bundle exec sidekiq -C config/sidekiq.yml
   ```

6. **Access the Application**
   - Web Application: `http://localhost:3000`
   - Sidekiq Dashboard: `http://localhost:3000/sidekiq`

---

## 📂 Folder Structure (Highlights)

| Path | Purpose |
|:-----|:--------|
| `app/models/` | Models: School, Family, Student, AuditLog, CsvUpload |
| `app/controllers/imports_controller.rb` | CSV Upload handling |
| `app/controllers/students_controller.rb` | Students + Family listing |
| `app/jobs/csv_processing_job.rb` | Background CSV processing |
| `app/services/csv_validation_service.rb` | Validate CSV rows |
| `app/services/csv_transition_service.rb` | Year 2 transition logic |
| `app/services/error_report_generator.rb` | Generate error CSVs |
| `app/services/completed_report_generator.rb` | Generate completed success CSVs |

---

## 📋 Features

- Upload CSV file from web UI.
- Full CSV validation:
  - Required fields check.
  - Email format validation.
  - Grade validation (1–12).
  - Duplicate row detection (full row duplicate).
  - Duplicate email detection (inside CSV or DB).
- Background job for processing.
- Full database transaction: rollback if any failure.
- Error report CSV generation (if validation fails).
- Completed report CSV generation (if upload succeeds).
- UI to list previous uploads and download reports.
- Sidekiq Web Dashboard for monitoring jobs.

---

## 📂 Sample CSVs for Testing

Inside `/sample_csvs/`:

| File | Purpose |
|:-----|:--------|
| `sample_correct.csv` | Valid data, should upload successfully |
| `sample_with_errors.csv` | Validation errors (bad grades, missing emails) |
| `sample_with_full_duplicates.csv` | Duplicate full rows |

✅ You can upload these from the UI to simulate real use cases.

---

## ✅ Key Business Rules Implemented

| Rule | Enforced? |
|:-----|:----------|
| No missing parent email | ✅ |
| No invalid email formats | ✅ |
| No invalid grades (must be 1–12) | ✅ |
| No duplicate entries inside CSV | ✅ |
| No duplicates with existing Families in DB | ✅ |
| Full rollback on processing error | ✅ |
| Downloadable reports for success/failure | ✅ |

---

## 🛠 Future Enhancements (Optional Ideas)

- Send email notification on success/failure.
- UI progress bar for processing uploads (using ActionCable).
- Upload very large CSVs via chunked upload / streaming.
- Advanced duplicate detection (e.g., fuzzy matching).

---

## Attachments 



https://github.com/user-attachments/assets/314e2644-9d97-4980-9497-884dd373453e


![StudentTransitionPortal-04-29-2025_12_13_AM](https://github.com/user-attachments/assets/944bf205-f588-400a-93a0-87bf03e0f398)
![StudentTransitionPortal-04-29-2025_12_13_AM (1)](https://github.com/user-attachments/assets/10bf6fd8-cdc8-4956-83f7-317410e9be82)
![StudentTransitionPortal-04-29-2025_12_13_AM (2)](https://github.com/user-attachments/assets/fab374f6-6227-4c90-8396-efccc6191ee4)
![-DEVELOPMENT-Sidekiq-04-29-2025_12_54_AM](https://github.com/user-attachments/assets/a4d9329c-0171-49c3-9bd0-45a691ee66cc)



## 🤝 Author

**[Akshay]**  
Rails Developer — passionate about building safe, scalable backend systems 🚀

"Hello, I’m excited to present the project I've built for the CSV Student Transition Proof-of-Concept assignment."
"The goal was to demonstrate my approach for:
CSV validation
Year 2 student transitions
Error handling with reporting
Full rollback on any processing error
Background processing using Sidekiq."

**Data Models Overview**
"I’ve designed three core models:
School: Represents the institution
Family: Represents the parent/guardian information
Student: Represents each student associated with a family"
"There are proper associations:
A school has many families.
A family has many students."

**CSV Upload Flow**
"From the UI, an admin can upload a CSV file containing parent and student data."
"Once the file is uploaded:
It triggers a background job using Sidekiq.
The file goes through a validation phase before any database change happens."

**CSV Validation Phase**
"In the validation step:
I check for missing critical fields like Email, Student Name, and Grade.
I verify email format.
I ensure student grades are within the valid range (1–12).
I detect duplicate emails inside the CSV and against the database.
I also detect full duplicate rows based on all important fields."
"If any issues are found:
An Error Report CSV is generated.
The upload is marked as failed."

**Processing Phase (Year 2 Transition)**
"If the validation passes:
I update existing Families and Students.
Student grades are updated according to the CSV.
Family information such as email, mobile, and address is refreshed."
"All database changes happen inside a single transaction.
If anything goes wrong midway, the entire transaction rolls back automatically."

**Reporting Phase**
"After successful processing:
A Completed Report CSV is generated showing all successfully updated records."
"Each upload record shows:
Status (Pending, Processing, Completed, Failed)
Links to download Error Report or Completed Report as needed."

**Additional Features**
"Some extra enhancements I added:
UI for viewing all uploaded students along with their family associations.
Sample CSVs prepared for easy testing: good data, bad data, full duplicates."

**Code Quality and Documentation**
"The project is structured using:
Separate Services for validation, transition, and report generation.
A clear README.md with setup instructions and sample files included."
"The system is modular, clean, and scalable for future improvements like email notifications or Turbo Streams."

---
