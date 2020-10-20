Attribute VB_Name = "Module1"
Sub StockMarket():

For Each ws In Worksheets

'Assignment of Variables
    Dim TickerSymbol As String
    Dim YearlyChange As Integer
    Dim PercentChange As Double
    Dim TotalStockVolume As Double
    Dim LastRow As Long
    Dim SummaryRow As Integer
    Dim StockOpen As Double
    Dim GreatestIncrease As Double
    Dim GreatestDecrease As Double
    Dim GreatestVolume As Double

'Cell titles and formatting

    ws.Cells(1, 9).Value = "Ticker"
    ws.Cells(1, 10).Value = "Yearly Change"
    ws.Cells(1, 11).Value = "Percent Change"
    ws.Cells(1, 12).Value = "Total Stock Volume"
    ws.Cells(1, 16).Value = "Ticker"
    ws.Cells(1, 17).Value = "Value"
    ws.Cells(2, 15).Value = "Greatest % Increase"
    ws.Cells(3, 15).Value = "Greatest % Decrease"
    ws.Cells(4, 15).Value = "Greatest Total Volume "
    ws.Range("K1").EntireColumn.NumberFormat = "0.00%"
    ws.Range("L1").EntireColumn.Style = "Currency"
    ws.Range("Q2:Q3").NumberFormat = "0.00%"

'Setting initial values
TickerRow = 2
TotalStockVolume = 0

'Populate ticker column and total stock volume
LastRow = ws.Cells(Rows.Count, 1).End(xlUp).Row
    'i is the data iterator
    For i = 2 To LastRow
        'Looping through the summary table to find ticker values
        If ws.Cells(i, 1).Value = ws.Cells(i + 1, 1).Value Then
            'Then adding the total volume to the overall total
            TotalStockVolume = TotalStockVolume + ws.Cells(i, 7).Value
        
        ElseIf ws.Cells(i, 1).Value <> ws.Cells(i + 1, 1).Value Then
            TotalStockVolume = TotalStockVolume + ws.Cells(i, 7).Value
            ws.Cells(TickerRow, 9).Value = ws.Cells(i, 1).Value
            ws.Cells(TickerRow, 12).Value = TotalStockVolume
        
            TickerRow = TickerRow + 1
            TotalStockVolume = 0
        
        End If
        Next i
        
    
TickerRow = TickerRow - 1
For i = 2 To TickerRow
    'Using finducntion to generate the open
    'and close value by looking through the ticker values
    YearOpen = ws.Columns(1).Find(What:=ws.Cells(i, 9), LookAt:=xlWhole).Row
    YearClose = ws.Columns(1).Find(What:=ws.Cells(i, 9), LookAt:=xlWhole, SearchDirection:=xlPrevious).Row
    
    'Assigning variable to the Yearly Change value
    YearlyChange = ws.Cells(i, 10).Value
    
    'Calculating Yearly Change
    YearlyChange = ws.Cells(YearClose, 6).Value - ws.Cells(YearOpen, 3).Value
    
    'Color formatting the Yearly Change Column
    If ws.Cells(i, 10).Value > 0 Then
        ws.Cells(i, 10).Interior.ColorIndex = 4
    Else
        ws.Cells(i, 10).Interior.ColorIndex = 3
    End If
    
    'Calculate percentage change
    If ws.Cells(YearOpen, 3).Value <> 0 Then
        ws.Cells(i, 11).Value = (ws.Cells(YearClose, 6) - ws.Cells(YearOpen, 3)) / ws.Cells(YearOpen, 3)
    Else
        ws.Cells(i, 11).Value = 0
    End If
    Next i
    
    'Set initial Values
    GreatestIncrease = 0
    GreatestDecrease = 0
    GreatestVolume = 0
    
    'Calculating Greatest Increase
    For j = 2 To LastRow
        If ws.Cells(j, 11).Value > GreatestIncrease Then
            GreatestIncrease = ws.Cells(j, 11).Value
            ws.Range("Q2").Value = GreatestIncrease
            ws.Range("Q2").Style = "Percent"
            ws.Range("Q2").NumberFormat = "0.00%"
            ws.Range("P2").Value = ws.Cells(j, 9).Value
        End If
    Next j

'Calculating Greatest Decrease
    For k = 2 To LastRow
        If ws.Cells(k, 11).Value < GreatestDecrease Then
            GreatestDecrease = ws.Cells(k, 11).Value
            ws.Range("Q3").Value = GreatestDecrease
            ws.Range("Q2").Style = "Percent"
            ws.Range("Q3").NumberFormat = "0.00%"
            ws.Range("P3").Value = ws.Cells(k, 9).Value
        End If
    
    Next k

'Calculating Greatest Volume
    For i = 2 To LastRow
        If ws.Cells(i, 12).Value > GreatestVolume Then
            GreatestVolume = ws.Cells(i, 12).Value
            ws.Range("Q4").Value = GreatestVolume
            ws.Range("Q4").Style = "Currency"
            ws.Range("P4").Value = ws.Cells(i, 9).Value
        End If
    Next i
    
    Range("K1").EntireColumn.NumberFormat = "0.00%"
    ws.Columns("A:Q").AutoFit
Next ws

End Sub
