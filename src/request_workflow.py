from db_connection import get_connection
from email_generator import generate_access_request_email
from outlook_email import send_access_request_email


def create_dashboard_user(first_name, last_name, email):
    """
    Creates or retrieves a dashboard user using the
    usp_CreateDashboardUser stored procedure.

    Returns:
        DashboardUserID if successful
        None if unsuccessful
    """

    conn = get_connection()

    if conn is None:
        print("Failed to connect to the database. Cannot create dashboard user.")
        return None

    try:
        cursor = conn.cursor()

        sql = """
        DECLARE @NewDashboardUserID INT;

        EXEC dbo.usp_CreateDashboardUser
            @FirstName = ?,
            @LastName = ?,
            @Email = ?,
            @DashboardUserID = @NewDashboardUserID OUTPUT;

        SELECT @NewDashboardUserID AS DashboardUserID;
        """

        dashboard_user_id = cursor.execute(
            sql,
            first_name,
            last_name,
            email
        ).fetchone()[0]

        conn.commit()

        print(f"Dashboard user ready. DashboardUserID: {dashboard_user_id}")

        return dashboard_user_id

    except Exception as e:
        print("Error creating dashboard user:", e)
        return None

    finally:
        conn.close()


def create_access_request(dashboard_user_id, contract_manager_id, request_type, request_status, requested_by, notes):
    """
    Creates an access request using the usp_CreateAccessRequest stored procedure.

    Returns:
        AccessRequestID if successful
        None if unsuccessful
    """

    conn = get_connection()

    if conn is None:
        print("Failed to connect to the database. Cannot create access request.")
        return None

    try:
        cursor = conn.cursor()

        sql = """
        DECLARE @NewAccessRequestID INT;

        EXEC dbo.usp_CreateAccessRequest
            @DashboardUserID = ?,
            @ContractManagerID = ?,
            @RequestType = ?,
            @RequestStatus = ?,
            @RequestedBy = ?,
            @Notes = ?,
            @AccessRequestID = @NewAccessRequestID OUTPUT;

        SELECT @NewAccessRequestID AS AccessRequestID;
        """

        access_request_id = cursor.execute(
            sql,
            dashboard_user_id,
            contract_manager_id,
            request_type,
            request_status,
            requested_by,
            notes
        ).fetchone()[0]

        conn.commit()

        print(f"Access request created. AccessRequestID: {access_request_id}")

        return access_request_id

    except Exception as e:
        print("Error creating access request:", e)
        return None

    finally:
        conn.close()


def add_client_to_access_request(access_request_id, client_id):
    """
    Adds a client to an access request using the usp_AddClientToAccessRequest stored procedure.
    
    Returns:
        True if successful
        False if unsuccessful
    """

    conn = get_connection()

    if conn is None:
        print("Failed to connect to the database. Cannot add client to access request.")
        return False
    
    try:
        cursor = conn.cursor()

        sql = """
        EXEC dbo.usp_AddClientToAccessRequest
            @AccessRequestID = ?,
            @ClientID = ?;
        """

        cursor.execute(
            sql,
            access_request_id,
            client_id
        )

        conn.commit()

        print(f"Client {client_id} added to access request {access_request_id}.")

        return True
    except Exception as e:
        print("Error adding client to access request:", e)
        return False
    
    finally:
        conn.close()


def log_access_request_email(access_request_id, email_type, sent_to, sent_cc, subject_line, body_text):
    """
    Logs an access request email using the usp_LogAccessRequestEmail stored procedure.
    
    Returns:
        True if successful
        False if unsuccessful
    """

    conn = get_connection()

    if conn is None:
        print("Failed to connect to the database. Cannot log access request email.")
        return False
    
    try:
        cursor = conn.cursor()

        sql = """
        EXEC dbo.usp_LogAccessRequestEmail
            @AccessRequestID = ?,
            @EmailType = ?,
            @SentTo = ?,
            @SentCC = ?,
            @SubjectLine = ?,
            @BodyText = ?
        """

        cursor.execute(
            sql,
            access_request_id,
            email_type,
            sent_to,
            sent_cc,
            subject_line,
            body_text
        )

        conn.commit()

        print(f"Email logged for access request {access_request_id}.")

        return True
    except Exception as e:
        print("Error logging access request email:", e)
        return False
    
    finally:
        conn.close()

def process_access_request(
        first_name,
        last_name,
        email,
        client_ids,
        client_codes,
        contract_manager_id,
        requested_by,
        notes,
        sent_to,
        sent_cc,
    ):
    """
    Processes a full dashboard access request workflow.

    Workflow:
    1. Create or retrieve dashboard user
    2. Create access request
    3. Add requested client relationships
    4. Generate email
    5. Display Outlook email draft
    6. Log email activity in SQL Server

    Returns:
        AccessRequestID if successful
        None if unsuccessful
    """
    dashboard_user_id = create_dashboard_user(first_name, last_name, email)
    if dashboard_user_id is None:
        print("Failed to create dashboard user. Aborting access request process.")
        return None
    
    access_request_id = create_access_request(
        dashboard_user_id = dashboard_user_id,
        contract_manager_id = contract_manager_id,
        request_type="Add",
        request_status="Draft",
        requested_by=requested_by,
        notes=notes,
    )
    if access_request_id is None:
        print("Failed to create access request. Aborting access request process.")
        return None
    
    for client_id in client_ids:
        if not add_client_to_access_request(access_request_id, client_id):
            print(f"Failed to add client {client_id} to access request. Aborting access request process.")
            return None

    subject_line, body_text = generate_access_request_email(first_name, last_name, email, client_codes)
    if not send_access_request_email(sent_to, sent_cc, subject_line, body_text):
        print("Failed to create email draft. Aborting access request process.")
        return None
    
    if not log_access_request_email(access_request_id, "Add", sent_to, sent_cc, subject_line, body_text):
        print("Failed to log access request email. Aborting access request process.")
        return None
    
    if not update_access_request_status(
        access_request_id=access_request_id,
        request_status="Pending",
        notes="Outlook draft generated and email activity logged."
    ):
        print("Failed to update access request status. Aborting access request process.")
        return None

    print(f"Access request process completed successfully. AccessRequestID: {access_request_id}")
    return access_request_id



def update_access_request_status(access_request_id, request_status, notes=None):
    conn = get_connection()

    if conn is None:
        print("Failed to connect to the database. Cannot update access request status.")
        return False

    try:
        cursor = conn.cursor()

        sql = """
        EXEC dbo.usp_UpdateAccessRequestStatus
            @AccessRequestID = ?,
            @RequestStatus = ?,
            @Notes = ?
        """

        cursor.execute(sql, access_request_id, request_status, notes)
        conn.commit()

        print(f"Access request status updated for ID: {access_request_id}")
        return True

    except Exception as e:
        conn.rollback()
        print("Error updating access request status:", e)
        return False

    finally:
        conn.close()

if __name__ == "__main__":

    process_access_request(
        first_name="John",
        last_name="Smith",
        email="john.smith@example.com",
        client_ids=[1, 3],
        client_codes=["CLIENT001", "CLIENT003"],
        contract_manager_id=1,
        requested_by="Christian Arroyo",
        notes="Testing full workflow process",
        sent_to="provana.support@example.com",
        sent_cc="itg.team@example.com"
    )
    
    """
    update_access_request_status(
        access_request_id=1,
        request_status="Pending",
        notes="Updated from Python test."
    )
    """