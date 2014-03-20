require 'sinatra'

FILE_CONFIG           = File.dirname(__FILE__) + "/classes.csv"

FOLDER = 'views/mock/'
FILE_LOGIN            = FOLDER + 'login.html'
FILE_WELCOME          = FOLDER + 'banner_welcome.html'
FILE_LOGIN_FAILED     = FOLDER + 'login_failed.html'
FILE_REG_AND_RECORDS  = FOLDER + 'banner_reg_and_records.html'
FILE_REGISTRATION     = FOLDER + 'banner_registration.html'
FILE_REG_AGREEMENT    = FOLDER + 'banner_reg_agreement.html'
FILE_SELECT_TERM      = FOLDER + 'banner_select_term.html'
FILE_LOOKUP_CLASSES   = FOLDER + 'banner_lookup_classes.html'
FILE_CLASS_LIST       = FOLDER + 'banner_class_list.html'
FILE_ADVANCED_SEARCH  = FOLDER + 'banner_advanced_search.html'
FILE_CLASS_RESULTS    = FOLDER + 'banner_class_results.html'

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

class Subject
	attr_reader :subject
	attr_reader :name

	def initialize(subj,nm)
		@subject = subj
		@name = nm
	end
end

# TODO: check against test user database for real authentication
def authenticate( username, password)
	if password == "test" and username == "student2"
		return true
	end

	return false
end



classes = Array.new
subjects = Array.new

#load all classes and subjects from config file
File.open( FILE_CONFIG, 'r') do |f1|
	while line = f1.gets
		parsed_values = line.split(",")

		#if there are two values it is a new subject
		if(parsed_values.size == 2)

			subject = parsed_values[0]
			name 	 = parsed_values[1]
			new_subject = Subject.new( subject, name)

			subjects.push( new_subject )

		#if there are more than two values it is a course
		else
			course_number = parsed_values[0]
			subject 			= parsed_values[1]
			course				= parsed_values[2]
			num_enrolled  = parsed_values[3]
			capacity			= parsed_values[4]
			name					= parsed_values[5]

			new_section = Section.new( course_number, subject, course, num_enrolled, capacity, name )
			classes.push( new_section )
		end
	end
end

get '/enterprise' do
	html_output = ""

	File.open( FILE_LOGIN, 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output
end

post '/login.do' do

	if authenticate params[:password], params[:inputEnterpriseId]

  	html_output = ""

		File.open( FILE_WELCOME, 'r') do |f1|
			while line = f1.gets
				html_output += line
			end
		end

	html_output

  else
  	html_output = ""
	  File.open( FILE_LOGIN_FAILED, 'r') do |f1|

			while line = f1.gets
				html_output += line
			end

		end
	html_output
  end

end

get '/reg_and_records' do
	html_output = ""

	File.open( FILE_REG_AND_RECORDS, 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output
end

get '/registration' do
	html_output = ""

	File.open( FILE_REGISTRATION, 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output
end

get '/registration_agreement' do
	html_output = ""

	File.open( FILE_REG_AGREEMENT, 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output
end

get '/select_term' do
	html_output = ""

	File.open( FILE_SELECT_TERM , 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output
end

post '/select_classes' do
	html_output = ""



	File.open( FILE_LOOKUP_CLASSES, 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	index = html_output.index("<!--OPTIONS-->")

	insertedOptions = ""
	for sub in subjects
		insertedOptions += "<OPTION VALUE=\""+sub.subject+"\">"+sub.name
	end

	html_output.insert(index,insertedOptions)

	html_output
end

post '/get_courses' do
	if params[:SUB_BTN] == "Course Search"
		html_output = ""

		File.open( FILE_CLASS_LIST, 'r') do |f1|
			while line = f1.gets
				html_output += line
			end
		end

		index = html_output.index("<!--SUBJECT-->")

		subName = "ERROR_NO_SUBJECT"
		for sub in subjects
			if(sub.subject== params[:sel_subj])
				subName = sub.name
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

		File.open( FILE_ADVANCED_SEARCH, 'r') do |f1|
			while line = f1.gets
				html_output += line
			end
		end

		index = html_output.index("<!--OPTIONS-->")

		insertedOptions = ""
		for sub in subjects
			insertedOptions += "<OPTION VALUE=\""+sub.subject+"\">"+sub.name
		end

		html_output.insert(index,insertedOptions)

		html_output
	end
end

post '/search_results' do
	output = ""

	File.open( FILE_CLASS_RESULTS, 'r') do |f1|
		while line = f1.gets
			output += line
		end
	end

	index = output.index("<!--SUBJECT-->")

	subName = "ERROR_NO_SUBJECT"
	for sub in subjects
		if(sub.subject == params[:sel_subj])
			subName = sub.name
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
