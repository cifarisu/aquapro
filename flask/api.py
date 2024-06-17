from flask import Flask, jsonify, request
import googlemaps
from datetime import datetime
import pandas as pd
import numpy as np
import time

class Ant:
    def __init__(self, num_cities):
        self.tour = np.concatenate(([0], np.random.permutation(np.delete(np.arange(num_cities), 0))))
        self.distance = np.inf

def calculate_total_distance(tour, distances):
    total_distance = np.sum(distances[tour[:-1], tour[1:]]) + distances[tour[-1], 0]
    return total_distance

def two_opt(tour, distances):
    num_cities = len(tour)
    for i in range(num_cities - 1):
        for j in range(i + 2, num_cities + int(i == 0)):
            if j - i == 1: continue
            new_tour = tour.copy()
            new_tour[i+1:j] = tour[j-1:i:-1]
            if calculate_total_distance(new_tour, distances) < calculate_total_distance(tour, distances):
                tour = new_tour
    return tour

def ant_colony_optimization(distances, num_iterations=100, num_ants=100, decay=1, alpha=1, beta=1):
    num_cities = len(distances)
    pheromones = np.ones((num_cities, num_cities))
    best_tour = None
    best_distance = np.inf
    best_iteration = None

    for iteration in range(num_iterations):
        decay = 1 - 1/(iteration + 1)
        ants = [Ant(num_cities) for _ in range(num_ants)]
        for ant in ants:
            for i in range(1, num_cities):
                p = pheromones[ant.tour[i], :] ** alpha * ((1.0 / (distances[ant.tour[i], :] + 1e-10)) ** beta)
                p[ant.tour[:i+1]] = 0
                if i < num_cities - 1:
                    ant.tour[i+1] = np.random.choice(range(num_cities), 1, p=p/np.sum(p))
            ant.tour = two_opt(ant.tour, distances)
            ant.distance = calculate_total_distance(ant.tour, distances)
            if ant.distance < best_distance:
                best_distance = ant.distance
                best_tour = ant.tour.copy()
                best_iteration = iteration
            pheromones[ant.tour[:-1], ant.tour[1:]] += 1.0 / ant.distance
        pheromones *= (1.0 - decay)

    return np.concatenate((best_tour, [0])), best_distance, best_iteration, num_iterations, num_ants

app = Flask(__name__)

results = {}  # Store the results here

@app.route("/", methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        nodes = request.get_json()  # Get the coordinates from the POST request

        gmaps_client = googlemaps.Client(key='123')
        now = datetime.now()

        source = "13.14312265082151, 123.72490529804402"
        destination = "13.143697278881184, 123.72756604934412"

        direction_result = gmaps_client.directions(source, destination, mode="driving", avoid="ferries", departure_time=now, transit_mode = 'bus')

        print(direction_result[0]['legs'][0]['distance'])
        print(direction_result[0]['legs'][0]['duration'])

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
                df['distance_text'] = df['distance_text'].astype(str)
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

        # Run ACO a large number of times to estimate the best known result
        best_known_result = np.inf
        for _ in range(10):
            best_route, total_distance, _, _, _ = ant_colony_optimization(distances, num_iterations=100, num_ants=10)
            if total_distance < best_known_result:
                best_known_result = total_distance

        # Initialize lists to store results
        best_routes = []
        total_distances = []
        running_times = []
        best_iterations = []

        # Run ACO 15 times
        for trial in range(15):
            start_time = time.time()
            best_route, total_distance, best_iteration, num_iterations, num_ants = ant_colony_optimization(distances, num_iterations=100, num_ants=10)
            end_time = time.time()

            # Store results
            best_routes.append(best_route)
            total_distances.append(total_distance)
            running_times.append(end_time - start_time)
            best_iterations.append(best_iteration)

        # Calculate statistics
        average_distance = np.mean(total_distances)
        std_dev_distance = np.std(total_distances)

        # Calculate percent error using the best result from all trials
        best_result = min(total_distances)
        percent_error = (best_result - best_known_result) / best_known_result * 100

        result = {
            "Best Route": best_route.tolist(),
            "Distances": [],
            "Total Distance": calculate_total_distance(best_route, distances),
            "Running Time": end_time - start_time,
        }

        # Calculate distances between nodes in the best route
        for i in range(len(best_route) - 1):
            from_node = best_route[i]
            to_node = best_route[i + 1]
            distance_between_nodes = distances[from_node][to_node]
            result["Distances"].append(distance_between_nodes)

        return jsonify(result)


        
    else:
        return "Send a POST request with your coordinates."

@app.route("/results", methods=['GET'])
def get_results():
    return jsonify(results)

if __name__ == '__main__':
    app.run(debug=True)
