DESCRIPTION:
This project utilzed some of the following programming languages, tools and frameworks:
javascript, CSS, html, python, R, Tableau, D3, Flask, SQLite and google refine.
The final product presented here, is a Flask-based server, hosting our work using the verious tools.
It shows our final product to the end-user, on every web browser.
The website itself can be found here: https://houston311.herokuapp.com/


INSTALLATION:
The project is deployed and hosted on Heroku server: https://houston311.herokuapp.com/
If you would like to run it yourself locally, follow these steps:
1. Clone/download this repo into your local machine.
2. Install python 3.7.x https://www.python.org/downloads/ , if not installed.
3. Open cmd/terminal.
4. Go to the projecet root directory - "cd [project location]"
5. Run: For linux: "source venv/bin/activate" or for windows: "venv\Scripts\activate". You should see (venv) on the left side of the command line.
6. Run "flask run"


EXECUTION:
Open a web browser and go to http://127.0.0.1:5000/
You can now interact with every user-related aspect of our project.
Prediction UI can be used to predict the ticket closing time. You can either enter the values in the UI directly and click Predict or upload a test data in the "Prediction" part, a sample of which is located under "[project_dir]/test data". If you manually load a file to predict, there will be an output file generated with predicted values.
To close the server, go to the the terminal and press CTRL+C.


NOTES:
* The website is best seen on a large monitor screen.
* The Data_Integration and Model_Building dirs conbsists the code that is not part of the deployment. In order to run that code, you should download the data, and run it separately.