"""
lowkenuinley AI generated, I'll rewrite properly once done with other scripts. 
'equipment number' box needs to be manually clicked once the page opens within 5s, python limitation
yeah.
"""

import tkinter as tk
from tkinter import messagebox
import pyautogui
import time
import webbrowser

EQUIPMENT_NUMBER = "Number Not Listed"
LOCATION = "20026"
CONTACT_NUMBER_NOT_LISTED = "teams"

def send(keys):
    """Send keystrokes via pyautogui."""
    pyautogui.typewrite(keys, interval=0.01)

def send_key(key):
    """Press a special key."""
    pyautogui.press(key)

def sleep(ms):
    time.sleep(ms / 1000)

def run_macro(mrn, waitlist_fin, encounter_fin, window):
    window.withdraw()  # hide the GUI while running

    try:
        # Open the ServiceNow URL
        webbrowser.open("https://uhcw.service-now.com/sp?id=sc_cat_item&sys_id=234c5ab11b30bd100068eb91b24bcb77")
        sleep(5000)

        # Equipment number
        send(EQUIPMENT_NUMBER)
        sleep(1000)
        send_key("tab")
        send(LOCATION)
        sleep(500)
        send_key("tab")
        sleep(500)
        send_key("enter")
        sleep(1000)

        send_key("tab")
        send(CONTACT_NUMBER_NOT_LISTED)
        send_key("tab")
        send_key("tab")
        send_key("tab")
        sleep(1000)

        send("i")  # inpatient
        send_key("enter")
        sleep(200)

        send_key("tab")
        send_key("tab")
        send(mrn)
        send_key("tab")
        send_key("tab")
        send(waitlist_fin)
        send_key("tab")
        send_key("tab")
        send("Inpatient")
        send_key("tab")
        send_key("tab")
        send(waitlist_fin)
        send_key("tab")
        send_key("tab")
        send("DSG")
        send_key("tab")
        send(f"Hello, please merge the waitlist: {waitlist_fin}. with the encounter FIN: {encounter_fin}. Thank you!")

    except Exception as e:
        messagebox.showerror("Error", f"Macro failed:\n{e}")
    finally:
        window.deiconify()  # show GUI again after completion

def update_ok_button(mrn_var, fin_var, enc_var, ok_btn):
    if mrn_var.get().strip() and fin_var.get().strip() and enc_var.get().strip():
        ok_btn.config(state="normal")
    else:
        ok_btn.config(state="disabled")

def create_gui():
    root = tk.Tk()
    root.title("Merge Ticket Maker")
    root.resizable(False, False)
    root.attributes("-topmost", True)

    # Styling
    font = ("Segoe UI", 10)
    pad = {"padx": 12, "pady": 6}

    mrn_var = tk.StringVar()
    fin_var = tk.StringVar()
    enc_var = tk.StringVar()

    def on_change(*_):
        update_ok_button(mrn_var, fin_var, enc_var, ok_btn)

    mrn_var.trace_add("write", on_change)
    fin_var.trace_add("write", on_change)
    enc_var.trace_add("write", on_change)

    # MRN
    tk.Label(root, text="MRN: *", font=font).grid(row=0, column=0, sticky="w", **pad)
    tk.Entry(root, textvariable=mrn_var, width=28, font=font).grid(row=0, column=1, **pad)

    # Waitlist FIN
    tk.Label(root, text="Waitlist FIN: *", font=font).grid(row=1, column=0, sticky="w", **pad)
    tk.Entry(root, textvariable=fin_var, width=28, font=font).grid(row=1, column=1, **pad)

    # Encounter FIN
    tk.Label(root, text="Encounter FIN: *", font=font).grid(row=2, column=0, sticky="w", **pad)
    tk.Entry(root, textvariable=enc_var, width=28, font=font).grid(row=2, column=1, **pad)

    # Required notice
    tk.Label(root, text="* Required fields", font=("Segoe UI", 9), fg="red").grid(
        row=3, column=0, columnspan=2, sticky="w", padx=12, pady=(0, 4)
    )

    def on_ok():
        run_macro(mrn_var.get().strip(), fin_var.get().strip(), enc_var.get().strip(), root)

    ok_btn = tk.Button(root, text="OK", width=10, font=font, state="disabled", command=on_ok)
    ok_btn.grid(row=4, column=0, columnspan=2, pady=(4, 12))

    # Bind Enter key to OK when enabled
    root.bind("<Return>", lambda e: on_ok() if ok_btn["state"] == "normal" else None)

    root.eval("tk::PlaceWindow . center")
    root.mainloop()

if __name__ == "__main__":
    create_gui()