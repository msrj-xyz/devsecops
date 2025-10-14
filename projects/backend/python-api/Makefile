.PHONY: install test docker run clean

install:
	pip install -r requirements.txt

test:
	pytest -q

docker:
	docker build -t devsecops-python-api .

run:
	python app.py

clean:
	-rm -rf __pycache__
