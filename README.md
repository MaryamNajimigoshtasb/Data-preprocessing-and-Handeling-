# Data-preprocessing-and-Handeling-
Cleaning Data
Part 1: Dataset and task description
I selected a dataset of Apartment/ Hotel listings for Data preparation and Handling Group project. Our data contains variables such as the listing ID, location of those listings- latitude, longitude and neighborhood, Host ID, price, customer reviews- the number of reviews, date of reviews and the number of reviews per month, number of properties listed by the host, availability of the accommodation during the year and the minimum number of nights it can be let out for. 
I have character as Ill as numerical variables in our dataset. Listing_name, Host_name, Neighbourhood are some of the character data type and price, number_of_reviews, calculated_host_listings_count, reviews_per_month, availability_365 are some of the numerical data type. I have last_review variable, which is in date format. Our dataset has some missing values too. 
I apply cleaning and transforming techniques on our dataset.
I look for missing values in the character dataset and treat them by replacing with “Not Available” or “Unknown”. I format the data, create derived variables, correct errors and analyze using frequency tables.
Also, I check for missing values, invalid, extreme, and errors for each numerical variable, analyze them using univariate, frequency functions, treat the missing values by replacing them with median or mode values, transforming the data where applicable
Part 2: Loading data
Since our dataset was quite large and was taking long for processing in SAS, I sampled and extracted 14862 observations for analysis purpose by running the code. 
Then, I created a library called clean to store the data and imported the sample data excel file containing sample dataset for analysis purpose. This was done using the Proc Import function.

Part 3: Dataset characteristics
3.1.	Target variable 
3.1.1.	I did frequency analysis to each categorical variables where proc sgplot and freq statement have been used to explore the inner distribution of them.
1)	Summary of Categorical variables
There are 5 Categorical variables in the Dataset:
•	Name
•	Host name
•	Neighborhood Group
•	Neighborhood
•	Room Type
All of them are Nominal.
2)	Analysis of Categorical variables
When I started with proc sgplot, some variables like neighbourhood_group and room_type shoId unbalanced distribution. Some neighborhoods like Brooklyn and Manhattan have very high Frequency over 6000, hoIver, frequencies of Bronx and Staten Island Ire very low which indicate the renting market in these places was far less hot than previous areas.
Additionally, in the chart of room_type there is also a trend of unbalanced in different room types where shared room shows a relatively loIr frequency in comparison with the other two types.
