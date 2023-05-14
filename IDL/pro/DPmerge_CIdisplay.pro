;
; Copyright (c) 2013-2023, Marc De Graef Research Group/Carnegie Mellon University
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without modification, are 
; permitted provided that the following conditions are met:
;
;     - Redistributions of source code must retain the above copyright notice, this list 
;        of conditions and the following disclaimer.
;     - Redistributions in binary form must reproduce the above copyright notice, this 
;        list of conditions and the following disclaimer in the documentation and/or 
;        other materials provided with the distribution.
;     - Neither the names of Marc De Graef, Carnegie Mellon University nor the names 
;        of its contributors may be used to endorse or promote products derived from 
;        this software without specific prior written permission.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
; OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
; USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
; ###################################################################
;--------------------------------------------------------------------------
; EMsoft:DPmerge_CIdisplay.pro
;--------------------------------------------------------------------------
;
; PROGRAM: DPmerge_CIdisplay.pro
;
;> @author Marc De Graef, Carnegie Mellon University
;
;> @brief Generates a display widget for the confidence index maps
;
;> @date 04/10/23 MDG 1.0 first attempt at a user-friendly interface
;--------------------------------------------------------------------------
pro DPmerge_CIdisplay,dummy

common DPmerge_widget_common, DPmergewidget_s
common DPmerge_data_common, DPmergedata

; the display widget will have a Close, Save, and Save format option available
; in addition to the display region.

; a few font strings (this will need to be redone for Windows systems)
fontstr='-adobe-new century schoolbook-bold-r-normal--14-100-100-100-p-87-iso8859-1'
fontstrlarge='-adobe-new century schoolbook-medium-r-normal--20-140-100-100-p-103-iso8859-1'
fontstrsmall='-adobe-new century schoolbook-medium-r-normal--14-100-100-100-p-82-iso8859-1'

;------------------------------------------------------------
; create the top level widget
DPmergewidget_s.CIdisplaybase = WIDGET_BASE(TITLE='Confidence Map Display Panel', $
                            /COLUMN, $
                            XSIZE=770, $
                            /ALIGN_LEFT, $
                            /TLB_MOVE_EVENTS, $
                            EVENT_PRO='DPmerge_CIdisplay_event', $
                            XOFFSET=DPmergedata.xlocationCIdisplay, $
                            YOFFSET=DPmergedata.ylocationCIdisplay)

block0 = WIDGET_BASE(DPmergewidget_s.CIdisplaybase, $
            XSIZE=750, $
            /ALIGN_CENTER, $
            /ROW)

; a close button
closedisplaybutton = WIDGET_BUTTON(block0, $
                                UVALUE='CLOSECIDISPLAY', $
                                VALUE='Close', $
                                /NO_RELEASE, $
                                EVENT_PRO='DPmerge_CIdisplay_event', $
                                SENSITIVE=1, $
                                /FRAME)

; a save button
savepattern = WIDGET_BUTTON(block0, $
                        VALUE='Save', $
                        /NO_RELEASE, $
                        EVENT_PRO='DPmerge_CIdisplay_event', $
                        UVALUE='SAVECIMAP', $
                        SENSITIVE=1, $
                        /FRAME)

; and a format selector
vals = ['jpeg','tiff','bmp']
DPmergewidget_s.imageformat = CW_BGROUP(block0, $
                        vals, $
                        /ROW, $
                        /NO_RELEASE, $
                        /EXCLUSIVE, $
                        FONT=fontstr, $
                        LABEL_LEFT = 'File Format', $
                        /FRAME, $
                        EVENT_FUNC ='DPmergeevent', $
                        UVALUE='IMAGEFORMAT', $
                        SET_VALUE=DPmergedata.imageformat)

; finally, the draw area...
block1 = WIDGET_BASE(DPmergewidget_s.CIdisplaybase, $
            XSIZE=680, $
            /ALIGN_CENTER, $
            /COLUMN)

DPmergewidget_s.CIdraw = WIDGET_DRAW(block1, $
            COLOR_MODEL=2, $
            RETAIN=2, $
            /FRAME, $
            /ALIGN_CENTER, $
            XSIZE=DPmergedata.CI_wd, $
            YSIZE=DPmergedata.CI_ht)

;------------------------------------------------------------
; realize the widget structure
WIDGET_CONTROL,DPmergewidget_s.CIdisplaybase,/REALIZE

; realize the draw widgets
WIDGET_CONTROL, DPmergewidget_s.CIdraw, GET_VALUE=drawID
DPmergewidget_s.CIdrawID = drawID
DPmergedata.CIdrawID = drawID

; and hand over control to the xmanager
XMANAGER,"DPmerge_CIdisplay",DPmergewidget_s.CIdisplaybase,/NO_BLOCK

end

