from flask import Flask, render_template, request, redirect, url_for, session, flash
import psycopg2
import bcrypt
from datetime import datetime

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# Database configuration
DATABASE_URL = "dbname=residence_db user=residence_user password=123 host=localhost"

def get_db_connection():
	conn = psycopg2.connect(DATABASE_URL)
	return conn

def get_residence_groups_for_user(user_id):
	query = """
		SELECT rg.group_id, rg.group_name, rg.total_rent, rg.address, rg.due_date, (rg.total_rent / COUNT(m.user_id)) AS user_share
		FROM ResidenceGroup rg
		JOIN Membership m ON m.group_id = rg.group_id
		WHERE m.user_id = %s
		GROUP BY rg.group_id
		"""
	conn = get_db_connection()
	cur = conn.cursor()
	cur.execute(query, (user_id,))
	groups = cur.fetchall()
	
	residence_groups = []
	
	for group in groups:
		group_id = group[0]
		cur.execute("""
			SELECT COUNT(*) FROM Membership WHERE group_id = %s
		""", (group_id,))
		num_members = cur.fetchone()[0]
		user_share = group[2] / num_members if num_members else 0
		residence_groups.append(group + (user_share,))
	
	#return groups
	return residence_groups

def get_group_by_id(group_id):
	cur = get_db_connection().cursor()
	cur.execute("SELECT group_id, group_name, total_rent, address, due_date FROM ResidenceGroup WHERE group_id = %s", (group_id,))
	row = cur.fetchone()
	if row:
		return {
			'group_id': row[0],
			'group_name': row[1],
			'total_rent': row[2],
			'address': row[3],
			'due_date': row[4]
		}
	return None


def get_user_by_id(user_id):
	query = "SELECT * FROM Users WHERE user_id = %s"
	conn = get_db_connection()
	cur = conn.cursor()
	cur.execute(query, (user_id,))
	user = cur.fetchone()  # Fetch the user data
	return user


@app.route('/dashboard')
def dashboard():
	if 'user_id' not in session:
    		return redirect(url_for('login'))
    
	user_id = session['user_id']
	user = get_user_by_id(user_id)  # Function to fetch user details from DB
	"""
	conn = get_db_connection()
	cur = conn.cursor()
	
	cur.execute(""
		SELECT rg.group_id, rg.group_name, rg.total_rent, rg.address, rg.due_date
		FROM ResidenceGroup rg
		JOIN Membership m ON rg.group_id = m.group_id
		WHERE m.user_id = %s
	"", (user_id,))
	
	groups = cur.fetchall()
	
	cur.execute(""
		SELECT message, sent_date, status
		FROM Notification
		WHERE user_id = %s
		ORDER BY sent_date DESC
		LIMIT 5
	"", (user_id,))
	
	notifications = cur.fetchall()
	cur.close()
	conn.close()
	
	return render_template('dashboard.html', groups=groups, notifications=notifications)
	   
	""" 
	# Get user's residence groups, payment status, etc.
	residence_groups = get_residence_groups_for_user(user_id)  # Fetch groups and other details from DB
	
	payments = {}
	conn = get_db_connection()
	cur = conn.cursor()
	group_ids = [group[0] for group in residence_groups]
	for group_id in group_ids:
		
		cur.execute("""
			SELECT payment_date, amount_paid, notes, status
			FROM Payment
			WHERE group_id = %s AND user_id = %s
			ORDER BY payment_date DESC
		""", (group_id, user_id))
		payments[group_id] = cur.fetchall()
		
	notifications = []
	if group_ids:
		cur.execute("""
			SELECT n.message, n.sent_date, n.status, rg.group_name
			FROM Notification n
			JOIN ResidenceGroup rg ON n.group_id = rg.group_id
			WHERE n.group_id = ANY(%s)
			ORDER BY sent_date DESC
		""", (group_ids,))
		notifications = cur.fetchall()
	cur.close()
	conn.close()
	
	#print(residence_groups)
	#print("hello")
	# Pass the data to the template
	return render_template('dashboard.html', user=user, residence_groups=residence_groups, payments=payments, notifications = notifications)
	


# Home page (simple dashboard)
@app.route('/')
def home():
	if 'user_id' in session:
	    	user_id = session['user_id']
	    	conn = get_db_connection()
	    	cur = conn.cursor()
	    	cur.execute('SELECT * FROM ResidenceGroup rg '
		        	'JOIN Membership m ON rg.group_id = m.group_id '
		        	'WHERE m.user_id = %s', (user_id,))
	    	groups = cur.fetchall()
	    	cur.close()
	    	conn.close()
	    	return render_template('dashboard.html', groups=groups)
	return redirect(url_for('login'))

# Register page
@app.route('/register', methods=['GET', 'POST'])
def register():
	if request.method == 'POST':
	    	full_name = request.form['full_name']
	    	email = request.form['email']
	    	password = request.form['password']
	    	#hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
	    	phone_number = request.form['phone_number']

	    	conn = get_db_connection()
	    	cur = conn.cursor()
	    	insert_q = """
	    		INSERT INTO Users (full_name, email, password, phone_number)
	    		VALUES (%s, %s, %s, %s)
	    	"""
	    	try:
	    		cur.execute(insert_q, (full_name, email, password, phone_number))
	    		conn.commit()
	    		flash('User registered successfully!', 'success')
	    		return redirect(url_for('login'))
	    	except psycopg2.IntegrityError:
	    		flash('Email already exists!', 'error')
	    	finally:
	    		cur.close()
	    		conn.close()

	return render_template('register.html')

# Login page
@app.route('/login', methods=['GET', 'POST'])
def login():
	if request.method == 'POST':
	    	email = request.form['email']
	    	password = request.form['password']

	    	conn = get_db_connection()
	    	cur = conn.cursor()
	    	cur.execute('SELECT * FROM Users WHERE email = %s', (email,))
	    	user = cur.fetchone()
	    	cur.close()
	    	conn.close()

	    	#if user and bcrypt.checkpw(password.encode('utf-8'), user[3].encode('utf-8')):
	    	if user and user[3] == password:
	    		session['user_id'] = user[0]
	    		flash('Login successful!', 'success')
	    		return redirect(url_for('dashboard'))
	    	flash('Invalid login credentials', 'error')

	return render_template('login.html')

# Logout page
@app.route('/logout')
def logout():
	session.pop('user_id', None)
	flash('You have logged out', 'info')
	return redirect(url_for('login'))

# Create Residence Group
@app.route('/create_group', methods=['GET', 'POST'])
def create_group():
	if 'user_id' not in session:
    		return redirect(url_for('login'))
    
	if request.method == 'POST':
	    	group_name = request.form['group_name']
	    	address = request.form['address']
	    	total_rent = float(request.form['total_rent'])
	    	due_date = datetime.strptime(request.form['due_date'], '%Y-%m-%d').date()
	   	 
	    	conn = get_db_connection()
	    	cur = conn.cursor()
	    	cur.execute('INSERT INTO ResidenceGroup (group_name, address, total_rent, due_date) '
		        	'VALUES (%s, %s, %s, %s) RETURNING group_id', (group_name, address, total_rent, due_date))
	    	group_id = cur.fetchone()[0]
	   	 
	    	cur.execute('INSERT INTO Membership (user_id, group_id, join_date) '
		        	'VALUES (%s, %s, %s)', (session['user_id'], group_id, datetime.now().date()))
	    	conn.commit()
	    	cur.close()
	    	conn.close()
	    	flash('Group created and you joined successfully!', 'success')
	    	return redirect(url_for('home'))

	return render_template('create_group.html')


"""
# Join Residence Group
@app.route('/join_group', methods=['GET', 'POST'])
def join_group():
	if 'user_id' not in session:
    		return redirect(url_for('login'))
    
	if request.method == 'POST':
	    	group_id = int(request.form['group_id'])

	    	conn = get_db_connection()
	    	cur = conn.cursor()
	    	cur.execute('INSERT INTO Membership (user_id, group_id, join_date) '
		        	'VALUES (%s, %s, %s)', (session['user_id'], group_id, datetime.now().date()))
	    	conn.commit()
	    	cur.close()
	    	conn.close()
	    	flash('You have joined the group!', 'success')
	    	return redirect(url_for('home'))

	conn = get_db_connection()
	cur = conn.cursor()
	cur.execute('SELECT group_id, group_name FROM ResidenceGroup')
	groups = cur.fetchall()
	cur.close()
	conn.close()
	return render_template('join_group.html', groups=groups)

"""

@app.route('/join_group', methods=['POST'])
def join_group():
	if 'user_id' not in session:
		return redirect(url_for('login'))

	user_id = session['user_id']
	group_name = request.form['group_name']

	conn = get_db_connection()
	cur = conn.cursor()

	# Check if the group exists by name
	cur.execute("SELECT group_id FROM ResidenceGroup WHERE group_name = %s", (group_name,))
	group = cur.fetchone()

	if group:
		group_id = group[0]
		cur.execute("SELECT * FROM Membership WHERE user_id = %s AND group_id = %s", (user_id, group_id))
		if cur.fetchone():
			flash("You're already a member of this group.", "warning")
		else:
			# Add the user to the group
			cur.execute("INSERT INTO Membership (user_id, group_id, join_date) VALUES (%s, %s, CURRENT_DATE)", (user_id, group_id))
			conn.commit()
			flash("You've successfully joined the group!", "success")
	else:
		flash("Group not found. Please check the group name.", "danger")
	
	cur.close()
	conn.close()
	
	return redirect(url_for('dashboard'))


@app.route('/make_payment', methods=['POST'])
def make_payment():
	if 'user_id' not in session:
		return redirect(url_for('login'))

	user_id = session['user_id']
	group_id = int(request.form['group_id'])  # Get the selected group_id from the form
	amount = request.form['amount']
	notes = request.form['notes']
	status = 'Paid'
	
	print(user_id, group_id, amount, notes, status)

	conn = get_db_connection()
	cur = conn.cursor()

	# Insert the payment into the Payment table
	cur.execute(
		"INSERT INTO Payment (payment_date, amount_paid, notes, status, user_id, group_id)"
		"VALUES (CURRENT_DATE, %s, %s, %s, %s, %s)",
		(amount, notes, status, user_id, group_id)
	)

	conn.commit()
	cur.close()
	conn.close()

	flash("Payment submitted successfully.", "success")
	return redirect(url_for('dashboard'))

@app.route('/add_notification', methods=['POST'])
def add_notification():
	if 'user_id' not in session:
		return redirect(url_for('login'))

	user_id = session['user_id']
	group_id = request.form['group_id']
	message = request.form['message']
	status = 'Read'

	conn = get_db_connection()
	cur = conn.cursor()
	cur.execute("""
		INSERT INTO Notification (message, sent_date, user_id, status, group_id)
		VALUES (%s, NOW(), %s, %s, %s)
	""", (message, user_id, status, group_id))
	conn.commit()
	cur.close()
	conn.close()

	flash("Notification sent successfully!", "success")
	return redirect(url_for('dashboard'))




if __name__ == '__main__':
	app.run(debug=True)

