Shape.SetFillColor("onhover:"..this, 16777215)
-----------------------------------------------------------------------
	--// Get the Selected Text
	local gSel = RichText.GetSelection("AddText")
	
	--// Getting the Text Color of Selected
	local gFormat = RichText.GetSelectionFormat("AddText", false)
	
	--// Displaying the ColorPicker
	local tColorPicker = SysDialog.Color(HighlightColorBar__Var,tFlags)
	


if tColorPicker then

			if tColorPicker.Decimal == 16777215 then --//White - Means Remove Highligting
			
						RichText.SetSelectionFormat("AddText", {Protected=true}, false)
						
						RTFtext = RichText.GetText("AddText", true)
						
						
						--//Removing any old highlighting
						local FindFirst = String.Find(RTFtext, "\\protect", 1, true)
						local FindSecond = String.Find(RTFtext, "\\protect0", 1, true)
						
						if FindFirst ~= -1 and FindSecond ~= -1 then
						

							local Midding = String.Mid(RTFtext, FindFirst, (FindSecond-FindFirst)+String.Length("\\protect0"))
							
							if Midding ~= "" then
							
								local CleanText = string.gsub(Midding,"(\\highlight%d*%s?)","")
								
								NEW_RTFtext = String.Replace(RTFtext, Midding, CleanText)
								
								
								
											-----------------------------------------------------------
											--// Fixing the Overlap Highlighting Text Between Highlighted Text
											local i,j = string.find(RTFtext, "\\highlight%d+", FindFirst)
											
											if i~= nil and j~= nil then
											
												local xtemp = String.Mid(RTFtext, i,(j-i)+1)
												
												if xtemp ~= "" then
												
													xtempHighlightColor = xtemp;
												
												
												else
												
													xtempHighlightColor = "\\highlight0"
												
												end
												
											else
											
												xtempHighlightColor = "\\highlight0"
											
											end
				
											--Dialog.Message("Start:"..i.." End:"..j,xtemp)
											-----------------------------------------------------------
								
								
							
							end
						
						elseif FindFirst ~= -1 and FindSecond == -1 then
						
								NEW_RTFtext = string.gsub(RTFtext,"(\\highlight%d*%s?)","")
								xtempHighlightColor = "\\highlight0"

						
						end
						
						
						-------------------------------------------------------------------------
						
						local ReplaceONE = String.Replace(NEW_RTFtext, "\\protect0", xtempHighlightColor)
						local ReplaceTWO = String.Replace(ReplaceONE, "\\protect", "\\highlight0")
						RichText.SetText("AddText", ReplaceTWO, true)
						
						
						RichText.SetSelection("AddText",gSel.End,gSel.End)
						Shape.SetFillColor("HiglightColorBar", tColorPicker.Decimal)
			
			
			else --// Highliting Any Color
			
			
			
						OrignalFontColor = RichText.GetSelectionFormat("AddText", true).TextColor
						
						
						local TargetColor = ("\\red"..tColorPicker.Red)..("\\green"..tColorPicker.Green)..("\\blue"..tColorPicker.Blue)
						RichText.SetSelectionFormat("AddText", {TextColor=tColorPicker.Decimal, Protected=true}, true)
						
						tblColor = {};
			
						
							RTFtext = RichText.GetText("AddText", true)
							----Dialog.Message("", RTFtext)
							local FindTag = String.Find(RTFtext, "{\\colortbl ;",1)
							
								if FindTag ~= -1 then
								
									local EndTag   = String.Find(RTFtext, "}",FindTag)
									
									local ColorTblText = String.Mid(RTFtext, FindTag, (EndTag-FindTag))
									
									----Dialog.Message("",RTFtext)
									tblColor= String.DelimitedToTable(ColorTblText, ";")
								
								end
						
				
						if tblColor then
						
							Table.Remove(tblColor,1)
							for index, value in pairs(tblColor) do
							
								 Xvalue = String.Replace(value, " ", "")
								 
								 if Xvalue == TargetColor then
								 
								 	TargetHighlightIndex = index;
								 
								 end
							
							
							end
						
						end
						
						
						
						
						--//Removing Any old highlighting
						local FindFirst = String.Find(RTFtext, "\\protect", 1, true)
						local FindSecond = String.Find(RTFtext, "\\protect0", 1, true)
						
						if FindFirst ~= -1 and FindSecond ~= -1 then
						
						
							local Midding = String.Mid(RTFtext, FindFirst, (FindSecond-FindFirst)+String.Length("\\protect0"))
							
							if Midding ~= "" then
							
								--Dialog.Message("", Midding)
							
								CleanText,SubsNumber = string.gsub(Midding,"(\\highlight%d*)","")
								
								--Dialog.Message("", CleanText)
								
								NEW_RTFtext = String.Replace(RTFtext, Midding, CleanText)
								
								
											-----------------------------------------------------------
											--// Fixing the Overlap Highlighting Text Between Highlighted Text
											local i,j = string.find(RTFtext, "\\highlight%d+", FindFirst)
											
											if i ~= nil and j~= nil then
											
												local xtemp = String.Mid(RTFtext, i,(j-i)+1)
												
												if xtemp ~= "" then
												
													xtempHighlightColor = xtemp;
												
												
												else
												
													xtempHighlightColor = "\\highlight0"
												
												end
												
											else
											
												xtempHighlightColor = "\\highlight0";
												
											end
			
											--Dialog.Message("Start:"..i.." End:"..j,xtemp)
											-----------------------------------------------------------

								
							
							end
							
							
						elseif FindFirst ~= -1 and FindSecond == -1 then --//ctrl+A Selection so, "\protect0' doesnt' exist, only '\protect' does.
						
							
								NEW_RTFtext,SubsNumber = string.gsub(RTFtext,"(\\highlight%d*)","")
								xtempHighlightColor = "\\highlight0"
								
								--Dialog.Message("", NEW_RTFtext)
								
						
						end
						-------------------------------------------------------------------------
						

						
						--// Checking Next Highlight
						
						
						
						--------------------------------------------
						
						local ReplaceONE = String.Replace(NEW_RTFtext, "\\protect0", xtempHighlightColor)
						local ReplaceTWO = String.Replace(ReplaceONE, "\\protect", "\\highlight"..TargetHighlightIndex)
						RichText.SetText("AddText", ReplaceTWO, true)
						
						

						
						RichText.SetSelection("AddText",gSel.Start,gSel.End+SubsNumber)
						
						RichText.SetSelectionFormat("AddText", {TextColor=OrignalFontColor}, false)
						
						RichText.SetSelection("AddText",gSel.End+SubsNumber,gSel.End+SubsNumber)
						Shape.SetFillColor("HiglightColorBar", tColorPicker.Decimal)
						
			
			
			end --(if tColorPicker.Decimal == 16777215 then --//White - Means Remove Highligting)
			
end