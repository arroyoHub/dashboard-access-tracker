import textwrap

def generate_access_request_email(first_name, last_name, email, client_codes):
    """
    Generates an email message for a new access request.
    
    Returns:
        subject, body
    """

    subject = f"Dashboard Access Request for {first_name} {last_name}"

    formatted_clients = ", ".join(client_codes) if client_codes else "None"

    body = textwrap.dedent(f"""\
        Hello,

        Please create dashboard access for the following user:
        - Name: {first_name} {last_name}
        - Email: {email}
        - Clients: {formatted_clients}

        Thank you.
    """)

    return subject, body

if __name__ == "__main__":
    subject, body = generate_access_request_email(
        first_name="John",
        last_name="Smith",
        email="john.smith@example.com",
        client_codes=["Client001", "Client003"]
    )
    print("Subject:", subject)
    print("Body:", body)