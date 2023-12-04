import os
from dotenv import load_dotenv
from langchain import PromptTemplate, HuggingFaceHub, LLMChain
from langchain.llms import OpenAI

load_dotenv()

token = os.getenv("OPENAI_API_KEY")


def get_alternative_recipe(title, recipe):
  template = '''
    
        Change the {title}: {recipe} to a more healthier one by using healthier alternative ingredients.
        If there is sugar in the recipe, replace about 70% of the sugar with sweetener.
        10 grams of sugar should be replaced by 1 gram of sweetener.
        Example: if the recipe has 10 grams of sugar, new recipe should have 7 grams of sugar and 0.3 gram of sweetener.
        Please only give one alternative for each ingredient 
        please include only the new ingredients and their quantities
    '''
  prompt = PromptTemplate(template=template,
                          input_variables=["title", "recipe"])

  llm = OpenAI(openai_api_key=token)

  llm_chain = LLMChain(prompt=prompt, llm=llm)
  #recipe = "1 egg \n 1 cup all purpose flour \n 2 tablespoon sugar \n 3 teaspoons baking powder \n 1/4 teaspoon salt \n 3/4 cup milk \n 2 tablespoons vegetable oil"
  #title = "Basic pancake recipe"
  print("Generating Results")
  result = llm_chain.run(recipe=recipe, title=title)
  print("finished generating")
  return result


def get_new_ingredient_sugar(ingredient):

  template = '''
     tell me the average {ingredient} sugar content per 100 grams, treat it as fact and return in this format: [ingredient],[sugar]

     an example:
     apple,5
     
    '''

  prompt = PromptTemplate(template=template, input_variables=["ingredient"])

  llm = OpenAI(openai_api_key=token)

  llm_chain = LLMChain(prompt=prompt, llm=llm)
  sugar_con = llm_chain.run(ingredient=ingredient)
  return sugar_con


def save_results(title, recipe):
  results = {}
  alternative_recipe = get_alternative_recipe(title, recipe)
  alternative_recipe = alternative_recipe.strip().split("/n")
  results["alternative_recipe"] = alternative_recipe
  return results


# print(get_new_ingredient_sugar(ingredient="corn syrup"))
recipeList2 = "1 egg \n 1 cup all purpose flour \n 2 tablespoon sugar \n 3 teaspoons baking powder \n 1/4 teaspoon salt \n 3/4 cup milk \n 2 tablespoons vegetable oil"
#recipeTitle2 = "Creamy Garlic Butter Pasta"

#print(get_alternative_recipe(recipeList2, recipeTitle2))
