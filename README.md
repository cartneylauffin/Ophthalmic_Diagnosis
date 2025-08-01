# CNN-Based Classification of Retinal Images for Ophthalmic Diagnosis

This project uses a Convolutional Neural Network (CNN) model to classify retinal images into 4 categories: **CNV**, **DME**, **DRUSEN**, and **NORMAL**. The model is trained on a labeled image dataset and deployed for real-time prediction using a web interface.

## 🚀 Features

- Trained with TensorFlow/Keras
- Achieves over 97% validation accuracy
- Interactive prediction UI using Streamlit
- Custom evaluation using F1-score and confusion matrix
- Model and training history saved for reuse

---

## 📂 Dataset

The dataset used for this project is publicly available at:

🔗 **[OCT and Fundus Images for Retinal Disease Classification](https://data.mendeley.com/datasets/rscbjbr9sj/3)**  
Published on Mendeley Data (Version 3) by **Ali Masoudi and colleagues**.

The dataset contains thousands of high-quality labeled optical coherence tomography (OCT) images for training and validation.

---

## 📁 Project Structure

```

├── app.py                   # Streamlit web app for predictions
├── recommendation.py        # (Optional) Extra helper or analysis logic
├── Training\_model.ipynb     # Jupyter notebook used for training
├── Model\_Prediction.ipynb   # Jupyter notebook for evaluating and testing
├── Trained\_Model.keras      # Saved Keras model
├── Training\_history.pkl     # Training history for plotting
├── requirements.txt         # List of dependencies
└── README.md                # Project description

````

---

## 🧠 Model Overview

- Input shape: (224, 224, 3)
- Architecture: Custom CNN or pre-trained backbone (MobileNet, etc.)
- Loss: `categorical_crossentropy`
- Optimizer: Adam
- Metrics: Accuracy, F1-Score

---

## 📊 Performance

| Metric         | Score        |
|----------------|--------------|
| Accuracy       | ~99% (train) |
| Val Accuracy   | ~97.2%       |
| Val F1-Score   | ~0.95        |
| Val Loss       | ~0.11        |

---

## 🖼️ Sample Prediction

Upload a retinal image via the web interface. The model returns the most likely disease class.

---

## 💻 How to Run

### 1. Clone the Repository

```bash
git clone https://github.com/cartneylauffin/Ophthalmic_Diagnosis.git
cd Ophthalmic_Diagnosis
````

### 2. Install Requirements

```bash
pip install -r requirements.txt
```

### 3. Run the App

```bash
streamlit run app.py
```

---

## 🧪 Test Model in Jupyter

```python
from tensorflow.keras.models import load_model
model = load_model("Trained_Model.keras")
```

Then use prediction functions from `Model_Prediction.ipynb`.

---

## 📌 Notes

* Dataset must be in the format:

  ```
  Dataset/
  ├── train/
  ├── val/
  └── test/
      ├── CNV/
      ├── DME/
      ├── DRUSEN/
      └── NORMAL/
  ```

* `.DS_Store` or hidden files should be excluded from class listing.

---
