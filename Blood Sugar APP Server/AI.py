import os
from dotenv import load_dotenv
from langchain import PromptTemplate, HuggingFaceHub, LLMChain
from langchain.llms import OpenAI

load_dotenv()

token = os.getenv("OPENAI_API_KEY")

def get_alternative_recipe(title, recipe):
    template = '''
        Title = {title}
        Recipe = {recipe}


        Change the {title} {recipe} to a more healthier one by using healthier alternative ingredients。
        If there is sugar in the recipe, only replace some of the sugar with artificial sweetener to reduce the sugar as much as possible
        Please only give one alternative for each ingredient 
        please include only the new ingredients and their quantities
    '''
    #adjust the {title} recipe so that {recipe} is healthier for diabetic patients by using healthier alternatives, including replacing some sugar with sweetener to keep its sweetness and replacing all purpose flour to a healthier flour
    prompt = PromptTemplate(template=template, input_variables=["title","recipe"])

    llm = OpenAI(
        openai_api_key=token
    )

    llm_chain = LLMChain(prompt=prompt, llm=llm)
    recipe = "1 egg \n 1 cup all purpose flour \n 2 tablespoon sugar \n 3 teaspoons baking powder \n 1/4 teaspoon salt \n 3/4 cup milk \n 2 tablespoons vegetable oil"  
    title = "Basic pancake recipe"
    result = llm_chain.run(recipe=recipe, title=title)
    return result

def save_results(title, recipe):
    results = {}
    alternative_recipe = get_alternative_recipe(title, recipe)
    alternative_recipe = alternative_recipe.strip().split("/n")
    results["alternative_recipe"] = alternative_recipe
    return results