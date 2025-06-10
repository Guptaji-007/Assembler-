import numpy as np
import talib
import pandas as pd

# Generate some mock data for demonstration (e.g., 100 days of prices)
np.random.seed(0)
close_prices = np.random.normal(100, 10, 100)  # Random close prices around 100

# Calculate the 50-day Simple Moving Average (SMA)
sma_50 = talib.SMA(close_prices, timeperiod=50)

# Calculate the 14-day Relative Strength Index (RSI)
rsi_14 = talib.RSI(close_prices, timeperiod=14)

# Create a DataFrame to display the results
data = pd.DataFrame({
    'Close': close_prices,
    'SMA_50': sma_50,
    'RSI_14': rsi_14
})

print(data.tail(20))  # Print the last 20 rows to see recent indicator values
