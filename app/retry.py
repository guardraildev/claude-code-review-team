import time
import requests

def fetch_with_retry(url, attempts=3, delay=1.0):
    """Fetch url, retrying on connection errors up to `attempts` times with exponential backoff."""
    last_error = None
    for i in range(attempts):
        try:
            return requests.get(url, timeout=5)
        except requests.ConnectionError as e:
            last_error = e
            if i < attempts - 1:
                time.sleep(delay * 2 ** i)
    raise last_error
