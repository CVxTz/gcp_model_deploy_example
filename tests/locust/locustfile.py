from locust import HttpUser, task


class Predict(HttpUser):
    @task
    def hello_world(self):
        self.client.post(
            "/predict/",
            json={"text": "Apple is looking at buying U.K. startup for $1 billion"},
        )
