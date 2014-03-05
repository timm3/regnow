require 'mechanize'

class CourseManager

  def initialize(netid="netid", password="password")
    @netid = netid
    @password = password # TODO: decrypt later
    @login_url = 'https://eas.admin.uillinois.edu/eas/servlet/EasLogin?redirect=https://webprod.admin.uillinois.edu/ssa/servlet/SelfServiceLogin?appName=edu.uillinois.aits.SelfServiceLogin&dad=BANPROD1'
    @select_term_url = 'https://ui2web1.apps.uillinois.edu/BANPROD1/bwskfcls.p_sel_crse_search'
    @current_term_crn = 'https://ui2web1.apps.uillinois.edu/BANPROD1/bwckschd.p_disp_detail_sched?term_in=120141&crn_in='
    @add_course_url = 'https://ui2web1.apps.uillinois.edu/BANPROD1/bwskfreg.P_AltPin'
    @bot = Mechanize.new
  end

  # log into self-service and chooses latest semester term
  def login
    page = @bot.get(@login_url)  
    login_form = page.form('easForm')
    login_form.inputEnterpriseId = @pool_netid
    login_form.password = @pool_password
    sleep 1
    page = @bot.submit(login_form, login_form.button_with(:value => 'Login'))
    sleep 1
    page = @bot.get(@select_term_url)
    term_form = page.form_with(:action => '/BANPROD1/bwckgens.p_proc_term_date')
    term_form.field_with(:name => 'p_term').options[1].select # Select Spring 2014 (latest) semester
    sleep 1
    page = @bot.submit(term_form, term_form.button_with(:value => 'Submit'))
  end

  def get_num_spots(crn)
=begin
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

  def register_course(crn)
    login
    page = @bot.get(@add_course_url)

    # TODO: submit CRN add whenever summer registration starts
  end
end
