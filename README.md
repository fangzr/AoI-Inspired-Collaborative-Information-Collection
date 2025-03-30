# AUV-Assisted IoUT Information Collection Framework

## Overview

In order to better explore the ocean, autonomous underwater vehicles (AUVs) have been widely applied to facilitate information collection. However, due to the large-scale deployment of sensor nodes in the Internet of Underwater Things (IoUT), a homogeneous AUV-enabled system cannot support timely and reliable information collection given the time-varying underwater environment and the energy/mobility constraints of AUVs. This project implements a multi-AUV-assisted heterogeneous underwater information collection scheme that aims to optimize the peak Age of Information (AoI). Our approach utilizes a limited service M/G/1 vacation queueing model to model the information exchange process. Within this framework, the optimal upper limit of the number of AUVs served in the queue is derived, along with the steady-state distribution of the queue length. In addition, a low-complexity adaptive algorithm for adjusting the upper limit of the queuing length is proposed. Simulation results validate the effectiveness of our scheme and algorithm, demonstrating superior performance in peak AoI compared to traditional methods.

[Full Paper (PDF)](https://www.researchgate.net/publication/348150409_AoI_Inspired_Collaborative_Information_Collection_for_AUV_Assisted_Internet_of_Underwater_Things)


## Framework

![Fig. 1: Heterogeneous Multi-AUV Information Collection Scheme for IoUT](https://raw.githubusercontent.com/fangzr/AoI-Inspired-Collaborative-Information-Collection/refs/heads/main/jiang1-3049239-large.gif)

As depicted in Fig. 1, a heterogeneous multi-AUV information collection scheme is proposed for the Internet of Underwater Things (IoUT) including the fixed sensor nodes in the seabed and two types of AUVs, namely H-AUV and V-AUV. H-AUV is designed for collecting the information from IoUT nodes fixed in the seabed and V-AUV can receive information from H-AUVs and send them to the surface station. Moreover, H-AUV moves on the 2-dimensional (2-D) plane over the seabed without surfacing, which is capable of supporting seamless coverage and long-time underwater operation for its easy deployment and maneuverability, while V-AUV is responsible for moving vertically between the surface and seabed to transmit the information. V-AUV improves energy efficiency by gathering information and uploading them to the surface station, thereby avoiding the floating and diving movements of H-AUV.


## Features

- **Queueing Model:** Implements a limited service M/G/1 vacation queueing model for underwater information exchange.
- **Adaptive Algorithm:** Provides a low-complexity algorithm to adjust the upper limit of the queue length.
- **Performance Metrics:** Simulates and evaluates the system based on queue length expectation, waiting time, peak AoI, and energy consumption.
- **Matlab Implementation:** All simulation code is provided in MATLAB for easy reproduction and further experimentation.

## File Structure

- **Coefficient_calculation.m**  
  Calculates complex coefficients for the queueing model based on input parameters such as queue length, vacation time, and AUV arrival rate.

- **G_limited_QT.m**  
  Implements the G-limited queueing model to compute the expected queue length and the AUV waiting time.

- **main.m**  
  The main simulation script that integrates all components. It simulates the proposed architecture, evaluates AoI and energy consumption, and determines the optimal queue capacity.

- **Q_M_Cal.m**  
  Computes the probability distribution of the queue using a generating function approach.

- **Queueing_energy_comsumption.m**  
  Calculates the energy consumption during the queueing process, including both waiting energy and the energy for AUV elevation.

- **SNR_gamma.m**  
  Computes the nominal signal-to-noise ratio (SNR) for underwater acoustic channels based on transmission distance and frequency.

- **Channel_capacity_IoUT.m**  
  Determines the underwater channel capacity given the transmission power, bandwidth, and SNR.

- **db_2_normal.m**  
  Provides conversion functions between decibel (dB) values and normal scale numbers.

- **UD_energy_comsumption.m**  
  Calculates the energy consumption for the upward and downward movements of AUVs.

- **Patrol_mode.m**  
  Computes the energy consumption during AUV patrol operations, including both data collection and AUV motion energy expenditures.

## Prerequisites

- **MATLAB:**  
  The code is implemented in MATLAB. Ensure that you have MATLAB installed (MATLAB R2018 or later is recommended).

- **Toolboxes:**  
  This project uses standard MATLAB functions. No additional toolboxes are required.

## Usage

1. **Clone or Download the Repository:**  
   Use Git to clone the repository or download the ZIP file.

2. **Open MATLAB:**  
   Navigate to the project directory.

3. **Run the Main Script:**  
   Execute `main.m` to start the simulation. The script will display key outputs, such as:
   - Expected queue length and waiting time.
   - Energy consumption in different operation modes.
   - Calculated peak AoI under various configurations.

4. **Modify Parameters (Optional):**  
   The `main.m` script includes a set of predefined parameters (e.g., AUV speeds, data collection rates, energy limits). Modify these parameters as needed to explore different simulation scenarios.

## Simulation Parameters

The simulation in `main.m` uses parameters including:
- AUV velocities (ascending, descending, and moving).
- Data collection and sensor node specifications.
- Energy consumption models for queueing, patrol, and transmission.
- Environmental settings such as water depth and acoustic channel parameters.

These settings can be adjusted to simulate various operational scenarios and to further optimize the AoI and energy consumption metrics.

## Citation

If you find this code useful in your research, please consider citing our work:

```
@ARTICLE{9312959,
  author={Fang, Zhengru and Wang, Jingjing and Jiang, Chunxiao and Zhang, Qinyu and Ren, Yong},
  journal={IEEE Internet of Things Journal}, 
  title={{AoI}-Inspired Collaborative Information Collection for {AUV}-Assisted Internet of Underwater Things}, 
  year={2021},
  volume={8},
  number={19},
  pages={14559-14571},
  publisher={IEEE}}
  
@ARTICLE{9451536,
  author={Fang, Zhengru and Wang, Jingjing and Du, Jun and Hou, Xiangwang and Ren, Yong and Han, Zhu},
  journal={IEEE Internet of Things Journal}, 
  title={Stochastic Optimization-Aided Energy-Efficient Information Collection in Internet of Underwater Things Networks}, 
  year={2022},
  volume={9},
  number={3},
  pages={1775-1789},
  publisher={IEEE}
}
```
