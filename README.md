# Motor Imagery Classification
Machine learning on motor imagery data.

[Motor imagery][1] is the task of imagining the movement of a limb. This will produce signals from the brain to the limb that are very similar to the signals that the actual movement of the limb would produce. There are multiple ways to sample these signals, but the most common way is to place Ag/AgCl electrodes on the scalp in the international [10-20 system][2]. In this project this was turned into a classification problem.
To develop and test algorithms we used [dataset 2a from BCI competition IV][3] which is a 4 class problem - left hand, right hand, feet and tongue. It is sampled at 250 Hz, using 22 EEG electrodes and 3 EOG electrodes.   

The main files for data set 2a are 

dataSet2AOVO.m

dataSet2AOVR.m

dataSet2aDeepAll.m

mainDataset2A.m

The first 2 utilize Filter Bank Common Spatial Patterns [(FBCSP)][4] with the one versus one (OVO) and the one versus rest (OVR) multi class extension respectively both using support vector machines (SVM) as the classification model. dataSet2aDeepAll.m trains a deep end to end convolutional neural network, with only minimal preproceesing by a 4th order low pass butterworth filter, filtering each signal. 
mainDataset2A.m uses a version that is inspired by linear discriminant analysis (LDA), 

Out of all these methods FBCSP using OVO performed better and was therefore adapted for a 5 class real time problem. Signals were sampled at 512 Hz using 16 EEG electrodes. The main file for online classification is onlineTrainingTop.m this was turned into a paper accepted for IEEE brains 7th annual winter conference:

[An Improved Five Class MI Based BCI Scheme for Drone Control Using Filter Bank CSP][5]


[1]: https://en.wikipedia.org/wiki/Motor_imagery
[2]: https://en.wikipedia.org/wiki/10%E2%80%9320_system_(EEG)
[3]: https://github.com/bregydoc/bcidatasetIV2a
[4]: https://ieeexplore.ieee.org/document/4634130
[5]: 
