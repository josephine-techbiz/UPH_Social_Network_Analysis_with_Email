# UPH_OR_UAS_2018
Social Network Analysis (email)

I. Latar Belakang

 Analisis jaringan sosial atau social network analysis (SNA) adalah proses analisis kuantitatif dan kualitatif dari jaringan sosial. Setiap proses atau sistem sosial yang dapat dikonseptualisasikan sebagai satu set unit dan satu set garis yang menghubungkan pasangan unit dapat dipelajari sebagai jejaring sosial. Contoh struktur sosial yang telah dipelajari sebagai jaringan adalah hubungan perdagangan antar negara dan hyperlink antar situs web.
Perkembangan jaringan sosial semakin pesat. Komunitas atau kelompok sosial merupakan wadah yang nyaman untuk saling bertukar informasi antar anggota. Dalam dunia nyata, mengidentifikasi pertukaran informasi mengenai topik yang saling tidak berhubungan merupakan hal yang realtif sulit. Untuk itu, salah satu tujuan dari SNA adalah untuk mendeteksi dan mengidentifikasi informasi, termasuk hubungan interaksi antar user, yang direpresentasikan sebagai graf. Representasi dengan menggunakan graf merupakan tipe representasi yang paling fundamental.
R adalah suatu kesatuan software yang terintegrasi dengan beberapa fasilitas untuk manipulasi, perhitungan dan penampilan grafik yang handal. R bukanlah suatu program statistika, tetapi merupakan sebuah lingkungan pemrograman yang banyak digunakan oleh para statistisi. Selain itu, R memiliki kemampuan menganalisis data dengan sangat efektif dan dilengkapi dengan operator pengolahan array dan matriks. Tidak kalah menariknya R memiliki kemampuan penampilan grafik yang sangat modern, demikian pula peragaan untuk datanya. Dengan banyaknya kemampuan yang dapat dilakukan oleh R, R juga berfungsi dalam proses social network analysis. Berbagai package yang telah tersedia dalam R dapat membantu melakukan social network analysis. 

II. Deskripsi Projek

  Sesuai dengan topik mengenai social network analysis (SNA), projek yang dibuat berdasarkan referensi dari github adalah Email Network Analysis using R1. Projek ini mengolah data yang didapatkan dari lembaga penelitian besar Eropa. Data tersebut merupakan informasi anonim tentang semua e-mail masuk dan keluar antara anggota lembaga penelitian. E-mail hanya mewakili komunikasi antara anggota lembaga (inti), tidak berisi pesan masuk atau pesan keluar ke seluruh dunia.
SNA yang akan ditampilkan dalam projek ini meliputi : Preview, Connection, Sent Table, Recieved Table, 2-hop Neighbors, Degree Centrality, Betweenness Centrality, Department, dan Discussion. Representasi data dalam projek ini dapat ditampilkan dengan beberapa pengaturan, seperti: Number of Connections, Font Size, Opacity, Number of Top Senders, Number of Receivers, The nth Person with Highest Degree Centrality, The nth Person with Highest Betweenness Centrality, The nth Person with Highest Indegree Centrality.

III. Metode

3.1	Data

Projek ini menggunakan data yang diperoleh dari website Stanford Network Analysis Project (SNAP).  Data yang digunakan adalah data Email-Eu-Core Network2.

3.2	Langkah Penggunaan

	Dalam menjalankan program ini, langkah pertama yang harus dilakukan adalah mengunduh data email melalui website SNAP, terdapat dua file yang dapat diunduh yaitu file yang memuat data email antar karyawan dan file yang memuat data departemen karyawan. Langkah selanjutnya yaitu mengunggah file-file tersebut ke dalam panel yang telah disediakan. Kemudian aplikasi dapat dijalankan untuk mengolah data yang ada di dalam file-file tersebut.

3.3	Output

	3.3.1	Preview
  
	Output yang pertama dikeluarkan adalah preview dari data yang diunggah berupa dua tabel yang mewakili setiap data.

	3.3.2	Connection
  
	Connection menampilkan output berupa grafik network dengan hubungan koneksi antar vertex sejumlah angka yang diinput user.

	3.3.3	Sent Table
  
			Sent table menampilkan banyaknya email yang dikirim oleh setiap id.

	3.3.4	Received Table
  
	Received table menampilkan banyaknya email yang diterima oleh setiap id.

	3.3.5	2-hop Neighbors
  
	2-hop neighbors menampilkan protokol dan algorimta untuk routing, pengelompokan, dan pembagian data terdistribusi. 2-hop neighbors menampilkan hal tersebut melalui dua tampilan yaitu from top senders dan from top receivers.

	3.3.6	Degree Centrality
  
	Degree centrality menampilkan id yang memiliki degree atau koneksi yang terbanyak dari setiap id. Degree centrality menampilkan hal tersebut melalui dua tampilan yang berbeda, per person untuk tampilan berupa tabel, dan 2-hop graph untuk tampilan berupa grafik network.

	3.3.7	Betweenness Centrality
  
	Betweenness centrality menampilkan jumlah jalur terpendek yang melewati suatu vertex. Betweenness centrality menampilkan hal tersebut melalui dua tampilan yang berbeda, per person untuk tampilan berupa tabel, dan 2-hop graph untuk tampilan berupa grafik network.

	3.3.8	Department
  
	Department menampilkan tabel berupa banyaknya email yang dikirim antar karyawan berdasarkan departemennya.

	3.3.9	Discussion
  
	Discussion menampilkan teks berupa kesimpulan mengenai data yang diolah.

IV. Library

4.1	shiny

Shiny adalah library yang menyediakan kerangka web yang elegan dan kuat untuk membangun aplikasi web menggunakan R. Shiny membantu mengubah analisis menjadi aplikasi web interaktif tanpa memerlukan HTML, CSS, atau pengetahuan JavaScript. Shiny juga berfungsi untuk membuat grafik yang reaktif dan juga real time grafik. Di dalam projek ini, shiny digunakan untuk membuat graph yang reaktif terhadap data sehingga dapat terus diperbarui

4.2	networkD3

NetworkD3 berfungsi untuk menyediakan fungsi yang disebut igraph_to_networkD3, yang menggunakan objek igraph untuk mengubahnya menjadi format yang digunakan networkD3 untuk membuat representasi jaringan. Di dalam projek ini, networkD3 berfungsi untuk membantu dalam proses pembuatan grafik.

4.3	igraph

igraph  dapat menangani grafik besar dengan sangat baik dan menyediakan fungsi untuk menghasilkan grafik acak dan reguler, visualisasi grafik, metode sentralitas dan lain-lain. Di dalam projek ini terdapat grafik yang dibuat dengan data yang besar sehingga library ini sangat membantu untuk menghasilkan grafik yang terstruktur dengan baik.

4.4	shinythemes

Library ini berfungsi untuk memberikan tema pada tampilan aplikasi yang dibuat dengan shiny. Banyak macam tema pilihan yang dapat dengan mudah mengubah tampilan keseluruhan aplikasi Shiny menggunakan package shinythemes ini seperti cerulean, cosmo, cyborg, dark, dan lainnya.


V. Hasil dan Kesimpulan

Berikut ini adalah tampilan hasil dari projek Email Network Analysis using R :

5.1	Preview		
