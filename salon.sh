#! /bin/bash

PSQL="psql --username=postgres --dbname=salon -t --no-align -c"

MAIN_MENU() {
  if  [[ $1 ]]
  then 
      echo "$1"
  else
      echo "How may we help you?"
  fi  

  echo -e "1) Cut\n2) Color\n3) Perm\n4) Style\n5) Trim\n6) Exit"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
      1) SCHEDULE_APPOINTMENT "$SERVICE_ID_SELECTED" ;;
      2) SCHEDULE_APPOINTMENT "$SERVICE_ID_SELECTED" ;;
      3) SCHEDULE_APPOINTMENT "$SERVICE_ID_SELECTED" ;;
      4) SCHEDULE_APPOINTMENT "$SERVICE_ID_SELECTED" ;;
      5) SCHEDULE_APPOINTMENT "$SERVICE_ID_SELECTED" ;;
      6) echo "Thanks for stopping in!" ;;
      *) MAIN_MENU "Please pick a valid service." ;;
  esac 
}

SCHEDULE_APPOINTMENT() {
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$1")
  GET_CUSTOMER_INFO
}

GET_CUSTOMER_INFO() {
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE

  # Check if customer exists
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
      # Create new customer
      echo -e "\nIt looks like you're a new customer. Please enter your name:"
      read CUSTOMER_NAME
      # Insert new customer
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  GET_APPOINTMENT_TIME
}

# Function to get appointment time
GET_APPOINTMENT_TIME() {
  echo -e "\nPlease enter the time for your appointment:"
  read SERVICE_TIME

  # Get customer ID
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # Inser appointment
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

}

echo -e "\n~~~~~~ Salon Appointment Scheduler ~~~~~~\n"
MAIN_MENU