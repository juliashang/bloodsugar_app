import re
import pandas as pd
import spacy 
from quantulum3 import parser
from spacy.matcher import Matcher

mlp = spacy.load('en_core_web_sm')
matcher = Matcher(mlp.vocab)

def getData():
    unitsHold = pd.read_csv("units.csv")
    ingredientHold = pd.read_csv("Ingredient,Sugar (per 100g).csv")
    holdOnlyIngredient = ingredientHold["Ingredient"].values.tolist()
    return unitsHold, ingredientHold, holdOnlyIngredient

def getListIngredients(ingredientList):
    allIngredient = []
    for ingredient in ingredientList:
        ingredient = ingredient.lower()
        line = ingredient.split()
        ingredient = re.sub(r'[^\w\s]', ' ', ingredient)
        words = ingredient.split()
        if len(words) > 1:
            pattern = []
            for word in words:
                pattern.append({"TEXT": word})
            # print(pattern)
            matcher.add(ingredient, [pattern])
            # print(words)
        else:
            allIngredient.append(ingredient)
    return allIngredient
        
def convertToGrams(amountOfItems, unit, dfUnits):
    try:
        value = dfUnits.loc[dfUnits["unit"] == unit]["grams"].values
        return value[0]*amountOfItems
    except:
        return 0

def sugarAmount(amount, ingredient, dfIngredients):
    try:
        value = dfIngredients.loc[dfIngredients['Ingredient'] == ingredient]['Sugar (per 100g)'].values
        return value[0] * amount / 100
    except:
        return 0

def fetchIngredient(text, ingredientList):
    ingredients = getListIngredients(ingredientList)
    pattern = [{"LEMMA": {"IN": ingredients}}]
    matcher.add("ingredients",[pattern])
    doc = mlp(text)
    matches = matcher(doc)
    # print(matches)
    for i in range(len(matches)):
        # match: id, start, end
        token = str(doc[matches[i][1]:matches[i][2]])
        # print('=====' + token)
        return token

def analyzeRecipe(recipeList):
    unitsHold, ingredientHold, holdOnlyIngredient = getData()
    result = {}
    ingredients = {}
    totalSugar = 0
    recipeList = recipeList.split('\n')
    for recipeLine in recipeList:
        if recipeLine and recipeLine.lower() != 'ingredient' and recipeLine.lower() != 'ingredients':
            quantity = parser.parse(recipeLine)
            unit, quantity = str(quantity[0].unit), quantity[0].value
            if unit:
                amount = convertToGrams(quantity, unit, unitsHold)
            elif quantity:
                amount = quantity
            recipeLine = re.sub(r'[^\w\s]', ' ', recipeLine)
            ingredient = fetchIngredient(recipeLine, holdOnlyIngredient)
            sugar = sugarAmount(amount, ingredient, ingredientHold)
            totalSugar += sugar
            ingredients[recipeLine] = f'{sugar} grams of sugar'
    result['ingredient'] = ingredients
    result['amount_sugar'] = round(totalSugar, 3)
    return result        
    

