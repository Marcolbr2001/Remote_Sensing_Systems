# Remote_Sensing_Systems
Worked with remote sensors at system level, from signal acquisition to data processing. Performed FTIR calibration and atmospheric retrievals using Python, and implemented radar CFAR detection and SAR imaging with MATLAB using real data acquired from physical lab instrumentation.

<pre>
FCMW_and_SAR/
├── data/ 
├── CFAR_Detection_Video 
├── developing.m
├── help_code.m
└── movie_maker.m
  
FTIR/
├── base_spectra/ # Reference gas spectra retrieved from scientific databases
├── elektro_files/ # Spectra files measured during the laboratory session
├── images/ # All images used in the final report
├── FTIR_scripts.ipynb # Python code for loading, calibrating and analyzing the spectra
├── FTIR_scripts.pdf # Printable version of the code (PDF)
└── Laboratory_Report.pdf # Final report with methodology and results
</pre>



---

## 📊 What’s inside

- **FTIR_scripts.ipynb**:  
  Main Jupyter Notebook with all data processing steps: loading spectra, radiometric correction, spectral fitting, and temperature/gas retrieval.

- **Laboratory_Report.pdf**:  
  The complete written report explaining setup, methods, results, and scientific discussion.

---

## 💡 Highlights

- Radiometric calibration using black-body measurements  
- Spectral analysis and curve fitting in Python  
- Real experimental data from lab instruments  
- Focus on temperature estimation and ammonia concentration retrieval

---

## 📷 Preview

Below is a sample plot from the analysis:

<p align="center">
  <img src="FTIR/images/sample_spectrum_plot.png" alt="FTIR spectral analysis example" width="600">
</p>

---

## 🛠 Dependencies

- Python 3.x
- NumPy, SciPy, Matplotlib
- Jupyter Notebook

---

## 📄 License

This project is part of an academic laboratory exercise and is shared for educational purposes only.
