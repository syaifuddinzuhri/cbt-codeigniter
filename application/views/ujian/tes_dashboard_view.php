<div class="container">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>
            SELAMAT DATANG <?php if (!empty($nama)) {
                                echo $nama;
                            }
                            if (!empty($group)) {
                                echo ' | ' . $group;
                            } ?>
            <small>di Ujian Online Berbasis Komputer</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
            <li class="active">dashboard</li>
        </ol>
    </section>

    <!-- Main content -->
    <section class="content">
        <?php
        if (!empty($informasi)) {
        ?>
            <div class="callout callout-info">
                <h4>Informasi</h4>
                <?php
                echo $informasi
                ?>
            </div>
        <?php
        } else {
        ?>
            <div class="callout callout-info">
                <h4>Informasi</h4>
                <p>Silahkan pilih Tes yang diikuti dari daftar tes yang tersedia dibawah ini. Apabila tes tidak muncul, silahkan menghubungi Operator yang bertugas.</p>
            </div>
        <?php
        }
        ?>

        <div class="panel panel-default">
            <div class="panel-heading">Data Siswa</div>
            <div class="panel-body">
                <div class="row">
                    <section class="col-md-2">
                        <?php
                        if ($data_user->foto != NULL) { ?>
                            <img src="<?php echo base_url() . 'public/uploads/peserta/' . $data_user->foto ?>" alt="" width="100">
                        <?php } else { ?>
                            <img src="<?php echo base_url() . 'public/uploads/peserta/notfound.png' ?>" alt="" width="100">
                        <?php }  ?>
                    </section>
                    <section class="col-md-10">
                        <h5>Username : <span style="font-weight: bold;"><?php echo $data_user->user_name ?></span> </h5>
                        <h5>Nama Lengkap : <span style="font-weight: bold;"><?php echo $data_user->user_firstname ?></span> </h5>
                        <h5>Kelas : <span style="font-weight: bold;"><?php echo $data_user->grup_nama ?></span> </h5>
                    </section>
                </div>
            </div>
        </div>

        <div class="box box-success box-solid">
            <div class="box-header with-border">
                <h3 class="box-title">Daftar Tes</h3>
            </div><!-- /.box-header -->
            <div class="box-body">
                <table id="table-tes" class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th class="all">Tes</th>
                            <th>Waktu Mulai Tes</th>
                            <th>Waktu Selesai Tes</th>
                            <th>Status</th>
                            <th class="all">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td> </td>
                            <td> </td>
                            <td> </td>
                            <td> </td>
                            <td> </td>
                            <td> </td>
                        </tr>
                    </tbody>
                </table>
            </div><!-- /.box-body -->
        </div><!-- /.box -->
    </section><!-- /.content -->
</div><!-- /.container -->

<script type="text/javascript">
    $(function() {
        $('#table-tes').DataTable({
            "paging": true,
            "iDisplayLength": 25,
            "bProcessing": false,
            "bServerSide": true,
            "searching": false,
            "aoColumns": [{
                    "bSearchable": false,
                    "bSortable": false,
                    "sWidth": "20px"
                },
                {
                    "bSearchable": false,
                    "bSortable": false
                },
                {
                    "bSearchable": false,
                    "bSortable": false,
                    "sWidth": "150px"
                },
                {
                    "bSearchable": false,
                    "bSortable": false,
                    "sWidth": "150px"
                },
                {
                    "bSearchable": false,
                    "bSortable": false,
                    "sWidth": "100px"
                },
                {
                    "bSearchable": false,
                    "bSortable": false,
                    "sWidth": "30px"
                }
            ],
            "sAjaxSource": "<?php echo site_url() . '/' . $url; ?>/get_datatable/",
            "autoWidth": false,
            "responsive": true
        });
    });
</script>