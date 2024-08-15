# Aqua Pro: Water Access Efficiency through Ant Colony Optimization

This project, **Aqua Pro**, aims to optimize water access efficiency using Ant Colony Optimization (ACO) combined with a 2-Opt Local Search strategy. The goal is to improve water distribution systems by minimizing the overall travel distance of water supply vehicles, thus ensuring more efficient and effective water delivery.

## Table of Contents

- [Introduction](#introduction)
- [Methodology](#methodology)
- [Results](#results)
- [Visualizations](#visualizations)
- [Conclusion](#conclusion)

## Introduction

Efficient water distribution is crucial, especially in areas with limited water resources. **Aqua Pro** addresses this challenge by implementing a computational model that optimizes the routes for water supply vehicles. The solution utilizes Ant Colony Optimization (ACO), a probabilistic technique inspired by the behavior of ants in finding the shortest paths, combined with a 2-Opt Local Search strategy to further refine the routes.

## Methodology

The project is built upon the following key components:

1. **Ant Colony Optimization (ACO)**: A metaheuristic inspired by the foraging behavior of ants, which is used to find optimal paths by simulating the pheromone trail-laying and following behavior of ants.
2. **2-Opt Local Search**: A local optimization algorithm that iteratively improves the solution by reversing segments of the route, aiming to reduce the overall travel distance.

The integration of ACO with 2-Opt Local Search enhances the efficiency of the water distribution system by ensuring that the solutions are both globally and locally optimized.

## Results

The analysis conducted in this project used the Google Maps API to calculate and optimize the distances between various nodes representing water distribution points. The Ant Colony Optimization (ACO) algorithm, combined with the 2-Opt Local Search strategy, was applied to find the most efficient routes for water delivery vehicles.

### Key Insights:
- **Distance Calculation**: The simulation involved calculating driving distances between source and destination coordinates using real-world data from the Google Maps API.
- **Route Optimization**: The ACO algorithm, refined by the 2-Opt Local Search, successfully minimized the travel distances, resulting in more efficient water distribution routes.
- **Performance**: The optimized routes showed a significant reduction in overall travel distance compared to the initial unoptimized routes, leading to more effective water delivery and reduced operational costs.

### Results Table
## Summary Results of ACO on eil51, kroA100 and kroA200
| Problem (Nodes)  | Best Result | Average Distance | Best Known Result | % Error | Running Time
|----------|-------------------------|-------------------------------|---------------------------|---------------------------|---------------------------|
| eil51    | 465.95                | 479.37[11.85]                       | 460.34                    | 1.22%                   | 28.51                   |
| kroA100  | 24669.14                 | 25647.47[617.39]                      | 23959.17                    | 2.96%                   | 71.46                    |
| kroA200  | 34503.34               | 37005.53[1389.20]                      | 34889.13                   | -1.11%                 | 175.90                    |

## Summary Results of ACO with 2-opt on eil51, kroA100 and kroA200
| Problem (Nodes)  | Best Result | Average Distance | Best Known Result | % Error | Running Time
|----------|-------------------------|-------------------------------|---------------------------|---------------------------|---------------------------|
| eil51    | 433.87                | 436.52[1.63]                       | 433.89                   | -0.005%                 | 167.94                  |
| kroA100  | 21846.21               | 22267.24[235.61]                     | 22060.63                   | -0.97%              | 913.76                  |
| kroA200  | 32617.88            | 33309.90[374.57]                     | 33054.82                | -1.32%                 | 1106.78                   |

## Visualizations

The node distribution position maps for ACO with 2-opt and standard ACO on eil51, kroA100, and kroA200 are shown in Figures 3, 4, and 5. The starting node of the pentagram is indicated by a round green dot and is labeled as node 0, while the end node is represented by a round red dot. The best route produced in 10 independent executions is shown by the red path, and the blue path represents the best-known route of the algorithm. By comparing the red paths (best results) with the blue paths (best-known solutions), we can evaluate the performance of the algorithms. The closer the red paths are to the blue paths, the more effective the algorithm is at approximating the best-known solution.

#### Figure 3: Node distribution position map for ACO with 2-opt on eil51
![Figure 3](https://github.com/cifarisu/aquapro/blob/main/Figure%203.%20Node%20Distribution%20map%20of%20ACO%20with%202-opt%20and%20standard%20ACO%20on%20eil51%20respectively.png)

#### Figure 4: Node distribution position map for ACO with 2-opt on kroA100
![Figure 4](https://github.com/cifarisu/aquapro/blob/main/Figure%204.%20Node%20Distribution%20map%20of%20ACO%20with%202-opt%20and%20standard%20ACO%20on%20krA100%20respectively.png)

#### Figure 5: Node distribution position map for ACO with 2-opt on kroA200
![Figure 5](https://github.com/cifarisu/aquapro/blob/main/Figure%205.%20Node%20Distribution%20map%20of%20ACO%20with%202-opt%20and%20standard%20ACO%20on%20krA200%20respectively.png)

## Conclusion

Based on the results above, conclusions can be drawn: 
1) Concerning the results with respect to the best, average, and optimal value in the ten independent trials, the ACO with 2-opt achieved the best performance on eil51, kroA100, and kroA200, while the standard ACO does not obtain any best result.
2) ACO with 2-opt has been observed to have a negative error percentage on eil51 and kroA100, which suggests that the algorithm has found a solution that is better than the previously best-known result, while on kroA200, both of the algorithms have a negative error percentage.
3) In terms of the running time, standard ACO has the fastest execution and produces the result on eil51, kroA100, and kroA200, while the ACO with 2-opt has the longest running time.

_For detailed results, please refer to the corresponding sections in the [Updated_Final_Algo](https://github.com/markjeromecifra/aquapro/blob/main/Updated_Final_Algo.ipynb) and [Aqua Pro Water Access Efficiency through Ant Colony Optimization with 2-Opt Local Search Strategy](https://github.com/markjeromecifra/aquapro/blob/main/Aqua%20Pro%20Water%20Access%20Efficiency%20through%20Ant%20Colony%20Optimization%20with%202-Opt%20Local%20Search%20Strategy.pdf)._





