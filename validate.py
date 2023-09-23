import requests
import re

# Define the server URL for RerID validation
SERVER_URL = 'http://qg.stvorec.eu.org/servers/rerid:3000'

# Function to validate a RerID
def validate_rerid(rerid):
    try:
        # Validate input: RerID format (e.g., "36-GHQ-456:1245")
        rerid_pattern = r'^\d{2}-(COM|NTB|PHN)-\d{3}:\d{4}$'
        if not re.match(rerid_pattern, rerid):
            raise ValueError('Invalid RerID format. Expected format: "xx-PLATFORM-xxx:xxxx".')

        # Prepare the request payload
        payload = {'rerid': rerid}

        # Send a POST request to the server for validation
        response = requests.post(SERVER_URL, data=payload)

        # Check the response status code
        if response.status_code == 200:
            # RerID is valid
            print('RerID is valid!')

            # Additional functionality can be added here, such as saving the validated RerID.

        elif response.status_code == 404:
            # RerID not found on the server
            print('RerID not found on the server.')
        else:
            # RerID is invalid for another reason
            print('RerID is invalid. Server response:', response.text)

            # Additional error handling or logging can be added here.

    except ValueError as ve:
        # Handle input validation errors
        print('Input validation error:', ve)
    except requests.exceptions.RequestException as re:
        # Handle request-related exceptions
        print('Request error:', re)
    except Exception as e:
        # Handle any other exceptions
        print('An error occurred:', e)

if __name__ == '__main__':
    # Get RerID from the user
    rerid = input('Enter RerID to validate: ')

    # Call the validation function
    validate_rerid(rerid)
