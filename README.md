# Stroke Prediction Project in R

## Project Summary

This project implements a complete Machine Learning (ML) workflow using **R** and the **`tidymodels`** ecosystem to predict whether a patient is likely to suffer a stroke based on their demographic and clinical data.

The project culminates in the deployment of the selected model as a **REST API** service using the **`vetiver`** and **`plumber`** packages, allowing the integration of predictions into clinical or external applications.

---

## Key Technologies and Packages

The project was entirely developed in the R environment using the following essential packages:

* **`tidyverse`**: For data manipulation, cleaning, and exploration (including `dplyr` and `ggplot2`).
* **`tidymodels`**: The main framework for modeling, covering data splitting, recipes (preprocessing), and workflows.
* **`themis`**: For handling class imbalance (using `step_smote`).
* **`ranger`**: For implementing the Random Forest algorithm.
* **`vetiver`** and **`pins`**: For model versioning and API deployment.
* **`plumber`**: For exposing the pinned model as a REST web service.
* **`skimr`**: For data summary and quick description.

---

## Project Tasks

The workflow was divided into five main tasks:

### Task 1: Data Import and Preprocessing

The goal was to prepare the dataset for modeling, as data quality is crucial for model performance.

* **Data Loading:** The `healthcare-dataset-stroke-data.csv` file was loaded.
* **Cleaning and Transformation:** Variables were recoded, and values like `"N/A"` and `"Unknown"` were changed to missing values or specific categories (`"missing"`).
* **Missing Value Imputation:** Missing values were handled, particularly in the `bmi` column.
* **Type Handling:** Variables were converted to the correct data types (numeric, factor).

### Task 2: Model Building

The `tidymodels` framework was used for the iterative construction of models.

* **Data Splitting:** Data was divided into training (70%) and testing sets, stratifying by the target variable (`stroke`).
* **Recipe (Preprocessing):** A `recipe` was created to automate preprocessing steps, including:
    * **Normalization** of numerical features.
    * **One-Hot Encoding** (dummy variables) of categorical features.
    * **Imbalance Handling:** **SMOTE (`step_smote`)** was applied to balance the minority class (`stroke = Yes`).
* **Trained Models:** Two candidate models were built using cross-validation (`vfold_cv`):
    1.  **Logistic Regression (`logistic_reg`)**
    2.  **Random Forest (`rand_forest`)**

### Task 3: Model Evaluation and Selection

Both models were evaluated based on key classification metrics.

* **Evaluation Metrics:** Performance was compared using `roc_auc`, `accuracy`, `sensitivity`, and `specificity`.
* **Final Selection:** The **Logistic Regression** model was selected for the initial deployment. Although Random Forest showed a higher overall `Accuracy` (0.947), its `Sensitivity` (ability to detect actual stroke cases) was critically low (0.0189). Logistic Regression offered a better balance between `Sensitivity` (0.761) and `Specificity` (0.763), making it a more **clinically responsible** choice.

### Task 4: Model Deployment

The final Logistic Regression model was prepared for deployment.

* **`vetiver` Object Creation:** The `vetiver_model` object (`v`) was created, combining the fitted model and the preprocessing recipe.
* **Pinning and Versioning:** The model was pinned (saved) to a local board (`board_folder`) using `vetiver_pin_write()`.
* **API Generation:** `vetiver_write_plumber()` was used to generate the necessary files for deployment, creating a **Plumber REST API** service.

### Task 5: Findings and Conclusions

The project successfully demonstrated an end-to-end ML workflow in R. The Logistic Regression model was deemed the most reliable choice for initial production due to its balanced performance. Future steps include optimizing the Random Forest model to improve its *Sensitivity* and exploring alternative class imbalance handling methods, such as *class weights*.

---

## Execution Instructions (API)

### Setup for Local Execution

I recommend placing the project files in a simple, structured location, such as your Desktop, for easy path management.

* In the **`Build-deploy-stroke-prediction-model-R.Rmd`** (Task 4) and **`plumber.R`** files, **update the absolute path** for the model board to your user:
    * Change: `"C:/Users/your_user/Desktop/stroke_api/model_board"`
* The **`stroke_api`** folder (containing `model_board`) should be kept **outside** your main project folder (`healthcare-prediction-stroke`).
* In the **`start_api.R`** file, **update the working directory** to your user, ensuring it points to the directory containing the main project files:
    * Change: `"C:/Users/your_user/Desktop/healthcare-prediction-stroke"`

To test the deployed model as a web service:

1.  **Run the Startup Script:** From R, RStudio or VSCode with R, run the startup script (`start_api.R` or similar) containing the code to launch the Plumber service:
    ```r
    # start_api.R
    library(plumber)
    pr <- pr("plumber.R")
    pr_run(pr)
    ```
2.  **Access Documentation:** Once the console shows the API is running (e.g., at `http://127.0.0.1:36416`), access the interactive documentation:
    ```
    [http://127.0.0.1](http://127.0.0.1):[PORT]/__docs__/
    ```
3.  **Make a Prediction (POST):** To get a prediction, send a **POST** request to the `/predict` route with the patient data in JSON format (including a placeholder value for the required `id` column):

    ```json
    [
      {
        "id": 12345,
        "gender": "Female",
        "age": 58.0,
        "hypertension": 0,
        "heart_disease": 1,
        "ever_married": "Yes",
        "work_type": "Private",
        "Residence_type": "Urban",
        "avg_glucose_level": 87.96,
        "bmi": 39.2,
        "smoking_status": "smokes"
      }
    ]
    ```