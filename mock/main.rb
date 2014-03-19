require 'sinatra'

class Section
	attr_reader :course_reg_number
	attr_reader :subject
	attr_reader :course
	attr_reader :num_enrolled
	attr_reader :capacity
	attr_reader :name

	def initialize(crn,subj,crs,enrol,cap,nm)
		@course_reg_number = crn
		@subject = subj
		@course = crs
		@num_enrolled = enrol
		@capacity = cap
		@name = nm
	end

	#users can register for classes only if number of students enrolled in less than capacity
	def canRegister
		if(num_enrolled.to_i<capacity.to_i)
			return true
		else
			return false
		end
	end
end


classes = Array.new
subjects = Array.new

	File.open(File.dirname(__FILE__) + "/classes.csv", 'r') do |f1|
		while line = f1.gets
			val = line.split(",")
			if(val.size == 2)
				subjects.push(val)
			else
				classes.push(Section.new(val[0],val[1],val[2],val[3],val[4],val[5]))
			end
		end
	end

get '/enterprise' do
	html_output = ""

	File.open('views/mock/login.html', 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output
end

post '/login.do' do

  if params[:password] == "test" and params[:inputEnterpriseId]=="student2"

  	html_output = ""

	File.open('views/mock/banner_welcome.html', 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output

  else
  	html_output = ""
  	File.open('views/mock/login_failed.html', 'r') do |f1|

		while line = f1.gets
			html_output += line
		end

	end
	html_output
  end

end

get '/reg_and_records' do
	html_output = ""

	File.open('views/mock/banner_reg_and_records.html', 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output
end

get '/registration' do
	html_output = ""

	File.open('views/mock/banner_registration.html', 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output
end

get '/registration_agreement' do
	html_output = ""

	File.open('views/mock/banner_reg_agreement.html', 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output
end

get '/select_term' do
	html_output = ""

	File.open('views/mock/banner_select_term.html', 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output
end

post '/select_classes' do
	html_output = ""



	File.open('views/mock/banner_lookup_classes.html', 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	index = html_output.index("<!--OPTIONS-->")

	insertedOptions = ""
	for sub in subjects
		insertedOptions += "<OPTION VALUE=\""+sub[0]+"\">"+sub[1]
	end

	html_output.insert(index,insertedOptions)

	html_output
end

post '/get_courses' do
	if params[:SUB_BTN] == "Course Search"
		html_output = ""

		File.open('views/mock/banner_class_list.html', 'r') do |f1|
			while line = f1.gets
				html_output += line
			end
		end

		index = html_output.index("<!--SUBJECT-->")

		subName = "ERROR_NO_SUBJECT"
		for sub in subjects
			if(sub[0]== params[:sel_subj])
				subName = sub[1]
			end
		end

		html_output.insert(index,"<TR><TH CLASS=\"ddheader\" scope=\"col\" colspan=\"4\" style=\"font-size:16px;\">"+subName+"</TH></TR>")


		rows = ""

		coursesListed = Array.new

		for course in classes

			if( (course.subject == params[:sel_subj]) && (!coursesListed.include?(course.course)))
				coursesListed.push(course.course)


				rows += "<TD CLASS=\"dddefault\"width=\"10%\">"+course.course+"</TD>
				<TD CLASS=\"dddefault\"width=\"35%\" text-align=\"left\">"+course.name+"</TD>
				<td>
				<FORM ACTION=\"/search_results\" METHOD=\"POST\" onSubmit=\"return checkSubmit()\">
				<input type=\"hidden\" name=\"term_in\" value=\"120141\" >
				<INPUT TYPE=\"hidden\" NAME=\"sel_subj\" VALUE=\"dummy\">
				<input type=\"hidden\" name=\"sel_subj\" value=\""+course.subject+"\" >
				<input type=\"hidden\" name=\"sel_crse\" value=\""+course.course+"\" >
				<input type=\"hidden\" name=\"SEL_TITLE\" value=\"\">
				<input type=\"hidden\" name=\"BEGIN_HH\" value=\"0\">
				<input type=\"hidden\" name=\"BEGIN_MI\" value=\"0\">
				<input type=\"hidden\" name=\"BEGIN_AP\" value=\"a\">
				<input type=\"hidden\" name=\"SEL_DAY\" value=\"dummy\">
				<input type=\"hidden\" name=\"SEL_PTRM\" value=\"dummy\">
				<input type=\"hidden\" name=\"END_HH\" value=\"0\">
				<input type=\"hidden\" name=\"END_MI\" value=\"0\">
				<input type=\"hidden\" name=\"END_AP\" value=\"a\">
				<input type=\"hidden\" name=\"SEL_CAMP\" value=\"dummy\">
				<input type=\"hidden\" name=\"SEL_SCHD\" value=\"dummy\">
				<input type=\"hidden\" name=\"SEL_SESS\" value=\"dummy\">
				<input type=\"hidden\" name=\"SEL_INSTR\" value=\"dummy\">
				<input type=\"hidden\" name=\"SEL_INSTR\" value=\"%\">
				<input type=\"hidden\" name=\"SEL_ATTR\" value=\"dummy\">
				<input type=\"hidden\" name=\"SEL_ATTR\" value=\"%\">
				<input type=\"hidden\" name=\"SEL_LEVL\" value=\"dummy\">
				<input type=\"hidden\" name=\"SEL_LEVL\" value=\"%\">
				<input type=\"hidden\" name=\"SEL_INSM\"  value=\"dummy\">
				<input type=\"hidden\" name=\"sel_dunt_code\"  value=\"\">
				<input type=\"hidden\" name=\"sel_dunt_unit\"  value=\"\">
				<input type=\"hidden\" name=\"call_value_in\"  value=\"\">
				<INPUT TYPE=\"hidden\" NAME=\"rsts\" VALUE=\"dummy\">
				<INPUT TYPE=\"hidden\" NAME=\"crn\" VALUE=\"dummy\">
				<input type=\"hidden\" name=\"path\" value=\"1\" >
				<INPUT TYPE=\"submit\" NAME=\"SUB_BTN\" VALUE=\"View Sections\" >
				</FORM>
				<BR>
				</td>
				</TR>"
			end
		end
		index = html_output.index("<!--COURSES-->")

		html_output.insert(index,rows)

		html_output
	else
		html_output = ""

		File.open('views/mock/banner_advanced_search.html', 'r') do |f1|
			while line = f1.gets
				html_output += line
			end
		end

		index = html_output.index("<!--OPTIONS-->")

		insertedOptions = ""
		for sub in subjects
			insertedOptions += "<OPTION VALUE=\""+sub[0]+"\">"+sub[1]
		end

		html_output.insert(index,insertedOptions)

		html_output
	end
end

post '/search_results' do
	output = ""
	#output += "search results for subj: "+params[:sel_subj]
	#output += " crs: "+params[:sel_crse]
	#output += " crn: "+params[:crn]

	File.open('views/mock/banner_class_results.html', 'r') do |f1|
			while line = f1.gets
				output += line
			end
	end

		index = output.index("<!--SUBJECT-->")

		subName = "ERROR_NO_SUBJECT"
		for sub in subjects
			if(sub[0]== params[:sel_subj])
				subName = sub[1]
			end
		end

		output.insert(index,"<TR><TH COLSPAN=\"26\" CLASS=\"ddtitle\" scope=\"colgroup\" >"+subName+"</TH></TR>")

		results =""
		for course in classes
		if( (course.subject == params[:sel_subj]) && (params[:sel_crse]=="" || params[:sel_crse]==course.course) && (params[:crn]=="dummy" || params[:sel_crn]==course.course_reg_number))
				if(course.canRegister)
				results += '<TR>
					<TD CLASS="dddefault"><ABBR title = "Available for registration">A</ABBR></TD>'
				else
				results += 	'<TR>
					<TD CLASS="dddefault"><ABBR title = Closed>C</ABBR></TD>'
				end

					results += '<TD CLASS="dddefault"><A HREF="/BANPROD1/bwckschd.p_disp_listcrse?term_in=120141&amp;subj_in=CS&amp;crse_in=125&amp;crn_in=31152" onMouseOver="window.status=\'Detail\';  return true" onFocus="window.status=\'Detail\';  return true" onMouseOut="window.status='';  return true"onBlur="window.status='';  return true">'+course.course_reg_number+'</A></TD>
					<TD CLASS="dddefault">'+course.subject+'</TD>
					<TD CLASS="dddefault">'+course.course+'</TD>
					<TD CLASS="dddefault">AL1</TD>
					<TD CLASS="dddefault">100</TD>
					<TD CLASS="dddefault">4.000</TD>
					<TD CLASS="dddefault">Intro to Computer Science</TD>
					<TD CLASS="dddefault">MWF</TD>
					<TD CLASS="dddefault">02:00 pm-02:50 pm</TD>
					<TD CLASS="dddefault">'+course.capacity+'</TD>
					<TD CLASS="dddefault">'+course.num_enrolled+'</TD>
					<TD CLASS="dddefault">'+(course.capacity.to_i-course.num_enrolled.to_i).to_s+'</TD>
					<TD CLASS="dddefault">0</TD>
					<TD CLASS="dddefault">0</TD>
					<TD CLASS="dddefault">0</TD>
					<TD CLASS="dddefault">0</TD>
					<TD CLASS="dddefault">0</TD>
					<TD CLASS="dddefault">0</TD>
					<TD CLASS="dddefault">Lawrence Christopher  Angrave (<ABBR title= "Primary">P</ABBR>)</TD>
					<TD CLASS="dddefault">01/21-05/07</TD>
					<TD CLASS="dddefault">1SIEBL 1404</TD>
					<TD CLASS="dddefault">UIUC: Quant Reasoning I</TD>
					</TR>'
				end
		end
	index = output.index("<!--SECTIONS-->")
	output.insert(index,results)

	output
end
