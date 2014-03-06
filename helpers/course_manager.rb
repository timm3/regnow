require 'mechanize'
require_relative 'database_manager'

class CourseManager

  def initialize(netid=$netid, password=$password)
    @netid = netid
    @password = password # TODO: decrypt later
    @login_url = 'https://eas.admin.uillinois.edu/eas/servlet/EasLogin?redirect=https://webprod.admin.uillinois.edu/ssa/servlet/SelfServiceLogin?appName=edu.uillinois.aits.SelfServiceLogin&dad=BANPROD1'
    @logout_url = 'https://ui2web1.apps.uillinois.edu/BANPROD1/twbkwbis.P_Logout'
    @select_term_url = 'https://ui2web1.apps.uillinois.edu/BANPROD1/bwskfcls.p_sel_crse_search'
    @current_term_crn = 'https://ui2web1.apps.uillinois.edu/BANPROD1/bwckschd.p_disp_detail_sched?term_in=120141&crn_in='
    @add_course_url = 'https://ui2web1.apps.uillinois.edu/BANPROD1/bwskfreg.P_AltPin'
    @bot = Mechanize.new
  end

  # log into self-service and chooses latest semester term
  def login
    page = @bot.get(@login_url)  
    login_form = page.form('easForm')
    login_form.inputEnterpriseId = @netid
    login_form.password = @password
    sleep 1
    page = @bot.submit(login_form, login_form.button_with(:value => 'Login'))
  end

  def choose_latest_semester
    sleep 1
    page = @bot.get(@select_term_url)
    term_form = page.form_with(:action => '/BANPROD1/bwckgens.p_proc_term_date')
    term_form.field_with(:name => 'p_term').options[1].select # Select Spring 2014 (latest) semester
    sleep 1
    page = @bot.submit(term_form, term_form.button_with(:value => 'Submit'))
  end

  def logout
    sleep 1
    page = @bot.get(@logout_url)
    logout_form = page.form_with(:action => 'logout.do')
    #pp page
    #sleep 1
    #page = @bot.submit(logout_form, logout_form.button_with(:value => 'Yes'))
  end

  def get_open_spots(crn)
=begin
    options_form = page.form_with(:action => '/BANPROD1/bwskfcls.P_GetCrse')
    page = @bot.submit(options_form, options_form.button_with(:value => 'Advanced Search'))
    crn_form = page.form_with(:action => '/BANPROD1/bwskfcls.P_GetCrse_Advanced')
    crn_form.crn = crn
    page = @bot.submit(crn_form, crn_form.button_with(:name => 'SUB_BTN'))
=end
    if !DatabaseManager.check_crn(crn)
      return false
    end
    page = @bot.get(@current_term_crn + crn.to_s)
    remaining_seats = page.search('/html/body/div[3]/table[1]/tr[2]/td/table/tr[2]/td[3]').first.text
    return remaining_seats.to_i
  end

  def get_total_spots(crn)
    if !DatabaseManager.check_crn(crn)
      return false
    end
    page = @bot.get(@current_term_crn + crn.to_s)
    total_seats = page.search('/html/body/div[3]/table[1]/tr[2]/td/table/tr[2]/td[2]').text
    return total_seats.to_i
  end

  def register_course(crn)
    if !DatabaseManager.check_crn(crn)
      return false
    end
    login
    choose_latest_semester
    page = @bot.get(@add_course_url)

    # TODO: submit CRN add whenever summer registration starts

    logout

    return true
  end
end
