function addColorToRTF(RawRTF, RED, GREEN, BLUE)

	--// First, check if the color alread exists in the table.
	  local colorIndex = 0
	  local colorTable = {}
	  for color in RawRTF:gmatch("\\red%d+\\green%d+\\blue%d+") do
	  
	    table.insert(colorTable, color)
	    
	    if color == string.format("\\red%d\\green%d\\blue%d", RED, GREEN, BLUE) then
	      colorIndex = #colorTable
	    end
	    
	  end
	

	
				--// If Exists, return its index
				if colorIndex ~= 0 then
				
					return colorIndex, RawRTF;
				
				end
				
				
				--// If NOT Exists, Add it
				local startPos = String.Find(RawRTF, "{\\colortbl", 1)
									
				if startPos ~= -1 then
				
					local endPos = String.Find(RawRTF, "}",startPos)
					
					local oldRTFcolorTable = String.Mid(RawRTF, startPos, (endPos-startPos))
					
					local newRTFcolorTable = oldRTFcolorTable .. string.format("\\red%d\\green%d\\blue%d", RED, GREEN, BLUE) .. ";"
					
					RawRTF = String.Replace(RawRTF, oldRTFcolorTable, newRTFcolorTable)
					colorIndex = (#colorTable)+1
					
					return colorIndex, RawRTF;
					
				end

end


------------------------------------------------------------------------------------------------------------------------------------------------------
--// TAKE the Index of the color in colortbl and Get its RGB
function IndexToColorTbl(RawRTF, Index)
	
	if Index == "\\highlight0" then
		return "\\highlight0";
	end
	
	--// First, check if the color alread exists in the table.
	  local colorIndex = tonumber(Index);
	  local colorTable = {}
	  
	  for color in RawRTF:gmatch("\\red%d+\\green%d+\\blue%d+") do
	  
	    table.insert(colorTable, color)

	  end
	  
	  if colorTable[colorIndex] then
	  
	  	return colorTable[colorIndex];
	  	
	  else
	  
	 	return "\\highlight0";
	 	
	  end
	  	
end	  

--// TAKE RGB Color and Find its Index in the colortbl.
function ColorTblToIndex(RawRTF, RGBcolor)

	if RGBcolor == "\\highlight0" then
		return "\\highlight0";
	end

	--// First, check if the color alread exists in the table.
	  local colorIndex = 0
	  local colorTable = {}
	  for color in RawRTF:gmatch("\\red%d+\\green%d+\\blue%d+") do
	  
	    table.insert(colorTable, color)
	    
		    if color == RGBcolor then
		      colorIndex = #colorTable
		      theColor = "\\highlight"..colorIndex
		      return theColor;
		    	
		    end
		    
	    
	  end	
	  
	  
	  
end
------------------------------------------------------------------------------------------------------------------------------------------------------
		--// Get the Selected Text
		local gSel = RichText.GetSelection("AddText")
		
		--// Get the Raw RTF
		--local RawRTF = RichText.GetText("AddText", true)


		--// Displaying the ColorPicker
		local tColorPicker = SysDialog.Color(HighlightColorBar__Var,tFlags)

		
		if tColorPicker then
		
			
			if tColorPicker.Decimal == 16777215 then --// White - Means Remove Highligting
			
										RichText.SetSelectionFormat("AddText", {Protected=true}, false)
										RawRTF = RichText.GetText("AddText", true)
										
												local startProtectedPos = String.Find(RawRTF, "\\protect", 1, true)
												local endProtectedPos   = String.Find(RawRTF, "\\protect0", 1, true)
										
										--------------------------------------------------
										--// No (\p0): Ctrl+A Selection
											if startProtectedPos ~= -1 and endProtectedPos == -1 then
											
												newRawRTF = string.gsub(RawRTF,"(\\highlight%d*%s?)","")
												newRawRTF = String.Replace(newRawRTF, "\\protect", "")
												
												--Dialog.Message("",newRawRTF)
												RichText.SetText("AddText", newRawRTF, true)
												RichText.SetSelection("AddText",gSel.End,gSel.End)
												Shape.SetFillColor("HiglightColorBar", tColorPicker.Decimal)
									
											
											end --(No (\p0): Ctrl+A Selection)
										--------------------------------------------------
										
										--------------------------------------------------
										--// YES (\p0): Specific Selection
											if startProtectedPos ~= -1 and endProtectedPos ~= -1 then
											
												--// Find Any Highlight Code after the Selected Area
												local xAfter, yAfter = string.find(RawRTF, "\\highlight%d+", endProtectedPos)
												
																	if xAfter~= nil and yAfter~= nil then
																	
																		local xtemp = String.Mid(RawRTF, xAfter,(yAfter-xAfter)+1)
																		
																		if xtemp ~= "" then
																		
																			if xtemp:match("%d+") ~= "0" then
																			
																				--xtempHighlightColor = "\\highlight0"
																				
																							local start_pos, end_pos, xtext = ReversePatternFind(RawRTF, "\\highlight%d+", xAfter)
																							
																							if xtext then
									
																									local xIndex = xtext:match("%d+")
																									xtempHighlightColor = IndexToColorTbl(RawRTF, xIndex)
																									--xtempHighlightColor = xtext;
																									
																							else
																							
																									xtempHighlightColor = "\\highlight0"
									
																							end --(if text then)
																			
																			elseif xtemp:match("%d+") == "0" then
																				
																				local start_pos, end_pos, xtext = ReversePatternFind(RawRTF, "\\highlight%d+", xAfter)
																				
																				if xtext then
						
																						local xIndex = xtext:match("%d+")
																						xtempHighlightColor = IndexToColorTbl(RawRTF, xIndex)
																						--xtempHighlightColor = xtext;
																						
																				else
																				
																						xtempHighlightColor = "\\highlight0"
						
																				end --(if text then)
																			
																			end --(if xtemp:match("%d+") ~= 0)
																		
																		end --(if xtemp ~= "")
																		
																	else --// If NOT Founded Any Highlight Code After: Search Backward.
																	
																				local start_pos, end_pos, xtext = ReversePatternFind(RawRTF, "\\highlight%d+", xAfter)
																				
																				if xtext then
						
																						local xIndex = xtext:match("%d+")
																						xtempHighlightColor = IndexToColorTbl(RawRTF, xIndex)
																						--xtempHighlightColor = xtext;
																						
																				else
																				
																						xtempHighlightColor = "\\highlight0"
						
																				end --(if text then)
																	
																	end --(if xAfter~= nil and yAfter~= nil)
																	
																	
																		--//Remove Any Highlighting Code Between \p and \p0
																		local CuttenArea = String.Mid(RawRTF, startProtectedPos, endProtectedPos-startProtectedPos)
																		local newCuttenArea = string.gsub(CuttenArea,"(\\highlight%d*%s?)","")
																		newRawRTF = String.Replace(RawRTF, CuttenArea, newCuttenArea)
																	
																	--//Take Action
																		--// Convert Needed Highligh RGB to Index
																		if xtempHighlightColor then
																			Final_tempHighlightColor = ColorTblToIndex(newRawRTF, xtempHighlightColor)
																		end
																		-----------------------------------------------------------------------
																	
																	newRawRTF = String.Replace(newRawRTF, "\\protect0", Final_tempHighlightColor)
																	newRawRTF = String.Replace(newRawRTF, "\\protect", "\\highlight0")
																	
																	RichText.SetText("AddText", newRawRTF, true)
																	RichText.SetSelection("AddText",gSel.End,gSel.End)
																	Shape.SetFillColor("HiglightColorBar", tColorPicker.Decimal)
									
																	
																	
											
											end --(YES (\p0): Specific Selection)
										--------------------------------------------------
			
			
			
			
			else --// Highliting Any Color
			
			
			
										RichText.SetSelectionFormat("AddText", {Protected=true}, false)
										RawRTF = RichText.GetText("AddText", true)
										
												local startProtectedPos = String.Find(RawRTF, "\\protect", 1, true)
												local endProtectedPos   = String.Find(RawRTF, "\\protect0", 1, true)
										
										--------------------------------------------------
										--// No (\p0): Ctrl+A Selection
											if startProtectedPos ~= -1 and endProtectedPos == -1 then
											
												newRawRTF = string.gsub(RawRTF,"(\\highlight%d*%s?)","")
												
												local colorIndex, xRawRTFx = addColorToRTF(newRawRTF, tColorPicker.Red, tColorPicker.Green, tColorPicker.Blue)
												
												newRawRTF = String.Replace(xRawRTFx, "\\protect", "\\highlight"..colorIndex)
												
												RichText.SetText("AddText", newRawRTF, true)
												RichText.SetSelection("AddText",gSel.End,gSel.End)
												Shape.SetFillColor("HiglightColorBar", tColorPicker.Decimal)
									
											
											end --(No (\p0): Ctrl+A Selection)
										--------------------------------------------------
										
										--------------------------------------------------
										--// YES (\p0): Specific Selection
											if startProtectedPos ~= -1 and endProtectedPos ~= -1 then
											
												--// Find Any Highlight Code after the Selected Area
												local xAfter, yAfter = string.find(RawRTF, "\\highlight%d+", endProtectedPos)
												
																	if xAfter~= nil and yAfter~= nil then
																	
																		local xtemp = String.Mid(RawRTF, xAfter,(yAfter-xAfter)+1)
																		
																		if xtemp ~= "" then
																		
																			if xtemp:match("%d+") ~= "0" then
																			
																				--xtempHighlightColor = "\\highlight0"
																				--Dialog.Message("Case", "d+ != 0 \nxtemp: "..xtemp)
																				
																						local start_pos, end_pos, xtext = ReversePatternFind(RawRTF, "\\highlight%d+", xAfter)
																						
																						if xtext then
								
																								local xIndex = xtext:match("%d+")
																								xtempHighlightColor = IndexToColorTbl(RawRTF, xIndex)
																								--xtempHighlightColor = xtext;
																								
																						else
																						
																								xtempHighlightColor = "\\highlight0"
								
																						end --(if text then)
																				
																			
																			elseif xtemp:match("%d+") == "0" then
																				
																				local start_pos, end_pos, xtext = ReversePatternFind(RawRTF, "\\highlight%d+", xAfter)
																				
																				if xtext then
						
																						local xIndex = xtext:match("%d+")
																						xtempHighlightColor = IndexToColorTbl(RawRTF, xIndex)
																						--xtempHighlightColor = xtext;
																						--Dialog.Message("Case", "d+ = 0 \nxtext Reverse Find: "..xtempHighlightColor)
																						
																				else
																				
																						xtempHighlightColor = "\\highlight0"
																						--Dialog.Message("Case", "d+ = 0 \nxtext Reverse Find: NOT FOUND")
						
																				end --(if text then)
																			
																			end --(if xtemp:match("%d+") ~= 0)
																		
																		end --(if xtemp ~= "")
																		
																	else --// If NOT Founded Any Highlight Code After: Search Backward.
																	
																				local start_pos, end_pos, xtext = ReversePatternFind(RawRTF, "\\highlight%d+", xAfter)
																				
																				if xtext then
						
																						local xIndex = xtext:match("%d+")
																						xtempHighlightColor = IndexToColorTbl(RawRTF, xIndex)
																						--xtempHighlightColor = xtext;
																						
																				else
																				
																						xtempHighlightColor = "\\highlight0"
						
																				end --(if text then)
																	
																	end --(if xAfter~= nil and yAfter~= nil)
																	
																	
																	--//Take Action
																	
																	
																		--//Remove Any Highlighting Code Between \p and \p0
																		local CuttenArea = String.Mid(RawRTF, startProtectedPos, endProtectedPos-startProtectedPos)
																		local newCuttenArea = string.gsub(CuttenArea,"(\\highlight%d*%s?)","")
																		newRawRTF = String.Replace(RawRTF, CuttenArea, newCuttenArea)
																		
																	local colorIndex, xRawRTFx= addColorToRTF(newRawRTF, tColorPicker.Red, tColorPicker.Green, tColorPicker.Blue)
																	
																		--// Convert Needed Highligh RGB to Index
																		if xtempHighlightColor then
																			Final_tempHighlightColor = ColorTblToIndex(xRawRTFx, xtempHighlightColor)
																		end
																		-----------------------------------------------------------------------
																	
																	newRawRTF = String.Replace(xRawRTFx, "\\protect0", Final_tempHighlightColor)
																	newRawRTF = String.Replace(newRawRTF, "\\protect", "\\highlight"..colorIndex)
																	
																	RichText.SetText("AddText", newRawRTF, true)
																	RichText.SetSelection("AddText",gSel.End,gSel.End)
																	Shape.SetFillColor("HiglightColorBar", tColorPicker.Decimal)

									
																	
																	
											
											end --(YES (\p0): Specific Selection)
										--------------------------------------------------
			
			
			
			end --(if tColorPicker.Decimal == 16777215)

			
		end --(if tColorPicker then)
		