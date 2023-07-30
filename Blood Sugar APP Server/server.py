import json
from flask import Flask, request, jsonify
from sugar_analyzer import analyzeRecipe
from AI import save_results

app = Flask(__name__)

@app.route('/')
def home():
    return 'Ingredient server'

@app.route('/analyze', methods=['POST'])
def sugarAnalyzer():
    data = json.loads(request.data)
    print(data)
    ingredient = data["ingredient"]
    result = analyzeRecipe(recipeList=ingredient)
    return jsonify(result)

@app.route('/alternative', methods=['POST'])
def alternative():
    data = json.loads(request.data)
    print(data)
    ingredient = data["ingredient"]
    title = data["title"]
    result = save_results(title=title, recipe=ingredient)
    return jsonify(result)

if __name__ == '__main__':
    app.run(host='0.0.0.0')