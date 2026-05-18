import win32com.client as win32


def send_access_request_email(sent_to, sent_cc, subject_line, body_text):
    """
    Creates and displays an Outlook email draft for a dashboard access request.

    Args:
        sent_to (str): Primary recipient email address.
        sent_cc (str): CC recipient email address.
        subject_line (str): Email subject line.
        body_text (str): Email body text.

    Returns:
        True if successful, False if unsuccessful.
    """

    try:
        try:
            outlook = win32.GetActiveObject("Outlook.Application")
        except Exception:
            outlook = win32.Dispatch("Outlook.Application")

        mail = outlook.CreateItem(0)  # 0 = olMailItem

        mail.To = sent_to
        mail.CC = sent_cc
        mail.Subject = subject_line
        mail.Body = body_text

        mail.Display()

        print("Email draft created successfully.")
        return True

    except Exception as e:
        print("An error occurred while creating the email draft:", e)
        return False