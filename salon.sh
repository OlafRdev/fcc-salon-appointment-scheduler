#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo "Welcome to My Salon, how can I help you?"
echo ""

echo "$($PSQL "SELECT service_id || ') ' || name FROM services ORDER BY service_id")"
read SERVICE_ID_SELECTED

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

while [[ -z $SERVICE_NAME ]]
do
    echo "I could not find that service. What would you like today?"
    echo "$($PSQL "SELECT service_id || ') ' || name FROM services ORDER BY service_id")"
    read SERVICE_ID_SELECTED
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
done

echo ""
echo "What's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_ID ]]
then
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
fi

echo ""
echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

echo ""
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."