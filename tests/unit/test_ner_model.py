from ner_app.ner_model import predict_entities


def test_predict_entities():
    text = "Apple is looking at buying U.K. startup for $1 billion"

    entities = predict_entities(text)

    assert entities == [
        {"end_idx": 5, "label": "ORG", "start_idx": 0, "text": "Apple"},
        {"end_idx": 31, "label": "GPE", "start_idx": 27, "text": "U.K."},
        {"end_idx": 54, "label": "MONEY", "start_idx": 44, "text": "$1 billion"},
    ]
