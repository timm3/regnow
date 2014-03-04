require 'mechanize'

class CourseManager

  def initialize
=begin
    @pool_netid = "netid" # TODO: pull from Mongo user pool
    @pool_password = "password" # TODO: pull from Mongo user pool
    @login_url = 'https://eas.admin.uillinois.edu/eas/servlet/EasLogin?redirect=https://webprod.admin.uillinois.edu/ssa/servlet/SelfServiceLogin?appName=edu.uillinois.aits.SelfServiceLogin&dad=BANPROD1'
    @select_term_url = 'https://ui2web1.apps.uillinois.edu/BANPROD1/bwskfcls.p_sel_crse_search'
=end
    @current_term_crn = 'https://ui2web1.apps.uillinois.edu/BANPROD1/bwckschd.p_disp_detail_sched?term_in=120141&crn_in='
    @bot = Mechanize.new
  end

  def add_course(name, crn, code, instructor)
    course = Course.create(:name => name, :crn => crn, :code => code, :instructor => instructor)
    course.save
  end

  def get_spots(crn)
=begin
    page = @bot.get(@login_url)  
    login_form = page.form('easForm')
    login_form.inputEnterpriseId = @pool_netid
    login_form.password = @pool_password
    page = @bot.submit(login_form, login_form.button_with(:value => 'Login'))
    page = @bot.get(@select_term_url)
    term_form = page.form_with(:action => '/BANPROD1/bwckgens.p_proc_term_date')
    term_form.field_with(:name => 'p_term').options[1].select # Select Spring 2014 (latest) semester
    page = @bot.submit(term_form, term_form.button_with(:value => 'Submit'))
    options_form = page.form_with(:action => '/BANPROD1/bwskfcls.P_GetCrse')
    page = @bot.submit(options_form, options_form.button_with(:value => 'Advanced Search'))
    crn_form = page.form_with(:action => '/BANPROD1/bwskfcls.P_GetCrse_Advanced')
    crn_form.crn = crn
    page = @bot.submit(crn_form, crn_form.button_with(:name => 'SUB_BTN'))
=end
    page = @bot.get(@current_term_crn + crn.to_s)
    remaining_seats = page.search('td:nth-child(4)').first.text
    return remaining_seats
  end

  def reset_database()
    Course.delete_all
    
    # TODO: populate courses collection here...
  end
end
