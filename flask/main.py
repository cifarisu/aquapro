from flask import Flask, jsonify
import googlemaps
from datetime import datetime
import pandas as pd
import numpy as np
import time

app = Flask(__name__)

class Ant:
    def __init__(self, num_cities):
        self.tour = np.concatenate(([0], np.random.permutation(num_cities - 1) + 1, [0]))  # Add 0 at the end
        self.distance = np.inf

def calculate_total_distance(tour, distances):
    total_distance = np.sum(distances[tour[:-1], tour[1:]])
    return total_distance  # No need to add distance back to starting city, it's already in the tour

def ant_colony_optimization(distances, num_iterations=10, num_ants=10, decay=0.1, alpha=1, beta=1):
    num_cities = len(distances)
    pheromones = np.ones((num_cities, num_cities))
    best_tour = None
    best_distance = np.inf

    for iteration in range(num_iterations):
        ants = [Ant(num_cities) for _ in range(num_ants)]
        for ant in ants:
            for i in range(1, num_cities):  # Start from 1 because the first city is fixed
                p = pheromones[ant.tour[i], :] ** alpha * ((1.0 / distances[ant.tour[i], :]) ** beta)
                p[ant.tour[:i+1]] = 0
                if i < num_cities - 1:  # Avoid the last city in ant.tour
                    ant.tour[i+1] = np.random.choice(range(num_cities), 1, p=p/np.sum(p))
            ant.distance = calculate_total_distance(ant.tour, distances)
            if ant.distance < best_distance:
                best_distance = ant.distance
                best_tour = ant.tour.copy()
            pheromones[ant.tour[:-2], ant.tour[1:-1]] += 1.0 / ant.distance  # Exclude the last city
        pheromones *= (1.0 - decay)

        print(f"Iteration {iteration + 1}/{num_iterations} - Best Distance: {best_distance}")

    return best_tour

@app.route("/")
def index():
    gmaps_client = googlemaps.Client(key='AIzaSyByRoj7S_CfYzWQjHgty1uSYSkCt7sG9FQ')
    now = datetime.now()

    source = "13.14312265082151, 123.72490529804402"
    destination = "13.143697278881184, 123.72756604934412"

    direction_result = gmaps_client.directions(source, destination, mode="driving", avoid="ferries", departure_time=now, transit_mode = 'bus')

    print(direction_result[0]['legs'][0]['distance'])
    print(direction_result[0]['legs'][0]['duration'])

    nodes = {
        'waterstation': (13.138486263526069, 123.73427819974167),
        'house1': (13.137190709035641, 123.73700332397237),
        'house2': (13.140090631446066, 123.73991297126756),
        'house3': (13.142451321798312, 123.73494979512034),
        'house4': (13.139258172064347, 123.73539635338554),
        'house5': (13.13999123347878, 123.73242355119558),
        'house6': (13.137754768117896, 123.73343149698927),
        'house7': (13.139916684943808, 123.7335208086423)
    }

    df = pd.DataFrame(columns=['from_node', 'to_node', 'from_lat_long', 'to_lat_long', 'distance', 'distance_text', 'from_lat', 'from_long'])

    rows = []
    for from_node, from_coords in nodes.items():
        for to_node, to_coords in nodes.items():
            row = {
                'from_node': from_node,
                'to_node': to_node,
                'from_lat_long': from_coords,
                'to_lat_long': to_coords,
                'distance': 0 if from_node == to_node else None,
                'distance_text': np.nan,
                'from_lat': from_coords[0],
                'from_long': from_coords[1],
            }
            rows.append(row)

    df = pd.concat([pd.DataFrame([row], columns=df.columns) for row in rows], ignore_index=True)

    start_time='now'
    for index, row in df.iterrows():
        if row['from_node'] != row['to_node']:
            direction_result = gmaps_client.directions(row['from_lat_long'], row['to_lat_long'], mode="driving", avoid="ferries", departure_time=start_time)
            df.loc[index, 'distance'] = direction_result[0]['legs'][0]['distance']['value']
            df.loc[index, 'distance_text'] = direction_result[0]['legs'][0]['distance']['text']
    distance_dict = df.set_index(['from_node', 'to_node'])['distance'].to_dict()
    distance = []

    for from_node in df.from_node.unique().tolist():
        distance_1d = []
        for to_node in df.to_node.unique().tolist():
            distance_1d.append(distance_dict[from_node,to_node]/1000)
        distance.append(distance_1d)

    distances = np.array(distance)
    distances = distances.copy()

    start_time = time.time()
    best_route = ant_colony_optimization(distances, num_iterations=100, num_ants=10)
    end_time = time.time()

    result = {
        "Best Route": best_route.tolist(),
        "Total Distance": calculate_total_distance(best_route, distances),
        "Running Time": end_time - start_time
    }

    return jsonify(result)

if __name__ == '__main__':
    app.run(debug=True)
