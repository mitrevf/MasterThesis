# MasterThesis
Semantic segmentation of aerial hyperspectral images based on deep learning methods.
Basic pipeline:
Preprocessing (PCA for dimensionality reduction) -> Unsupervised feature extraction (Convolutional Autoencoder) -> Classification (SVMs).
Method described in README file, requires MATLAB with libSVM library and Torch7 for running autoenoder neural network with dependencies listed in the README. Achieved performance beats the state of the art in the field, recording 99.9% accuracy or more for semantic segmentation in most test cases. Used hyperspectral databases are Indian Pines, Salinas, SalinasA, Pavia University and Pavia Centre. 
