from typing import List

from fastapi import FastAPI
from pydantic import BaseModel

from ner_app.ner_model import predict_entities


class Query(BaseModel):
    text: str


class Entity(BaseModel):
    text: str
    label: str
    start_idx: int
    end_idx: int


class Response(BaseModel):
    text: str
    entities: List[Entity]


app = FastAPI()


@app.post("/predict/", response_model=Response)
def create_item(in_query: Query):
    entities = predict_entities(in_query.text)

    return Response(text=in_query.text, entities=[Entity(**x) for x in entities])
