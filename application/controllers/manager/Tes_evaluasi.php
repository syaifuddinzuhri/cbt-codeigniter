<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/**
* MANUSGI CBT
* Syaifuddin Zuhri
* zuhrideveloper@gmail.com
* manusunangiri@gmail.com
*/
class Tes_evaluasi extends Member_Controller {
	private $kode_menu = 'tes-evaluasi';
	private $kelompok = 'tes';
	private $url = 'manager/tes_evaluasi';
	
    function __construct(){
		parent:: __construct();
		$this->load->model('cbt_user_model');
		$this->load->model('cbt_user_grup_model');
		$this->load->model('cbt_tes_model');
		$this->load->model('cbt_tes_token_model');
		$this->load->model('cbt_tes_topik_set_model');
		$this->load->model('cbt_tes_user_model');
		$this->load->model('cbt_tesgrup_model');
		$this->load->model('cbt_soal_model');
		$this->load->model('cbt_jawaban_model');
		$this->load->model('cbt_tes_soal_model');
		$this->load->model('cbt_tes_soal_jawaban_model');

		parent::cek_akses($this->kode_menu);
	}
	
    public function index($page=null, $id=null){
        $data['kode_menu'] = $this->kode_menu;
        $data['url'] = $this->url;

        $query_tes = $this->cbt_tes_user_model->get_by_group();
        $select = '';
        if($query_tes->num_rows()>0){
        	$query_tes = $query_tes->result();
        	foreach ($query_tes as $temp) {
        		$select = $select.'<option value="'.$temp->tes_id.'">'.$temp->tes_nama.'</option>';
        	}
        }
        $data['select_tes'] = $select;
        
        $this->template->display_admin($this->kelompok.'/tes_evaluasi_view', 'Evaluasi Jawaban', $data);
    }

    private function get_nilai_maksimal_essay($tes_id){
        $nilai_maksimal = 0;
        $total_essay = 0;
        $total_objektif = 0;

        if(!empty($tes_id)){
            $query_aktual = $this->cbt_tes_user_model->get_komposisi_soal_aktual($tes_id);
            if($query_aktual->num_rows()>0){
                $komposisi = $query_aktual->row();
                $total_essay = intval($komposisi->total_essay);
                $total_objektif = intval($komposisi->total_objektif);
            }

            if($total_essay==0){
                $query = $this->cbt_tes_user_model->get_komposisi_soal($tes_id);
                if($query->num_rows()>0){
                    $komposisi = $query->row();
                    $total_essay = intval($komposisi->total_essay);
                    $total_objektif = intval($komposisi->total_objektif);
                }
            }

            if($total_essay>0){
                $nilai_maksimal = $this->hitung_nilai_maksimal_essay($total_essay, $total_objektif);
            }
        }

        return round($nilai_maksimal, 2);
    }

    private function hitung_nilai_maksimal_essay($total_essay, $total_objektif){
        $nilai_maksimal = 0;

        if($total_essay>0){
            $nilai_maksimal = (100-$total_objektif)/$total_essay;
            if($nilai_maksimal<0){
                $nilai_maksimal = 0;
            }
        }

        return round($nilai_maksimal, 2);
    }

    private function get_nilai_maksimal_essay_by_tessoal($tessoal_id){
        $nilai_maksimal = 0;
        $query_tesuser = $this->cbt_tes_user_model->get_tesuser_by_tessoal($tessoal_id);

        if($query_tesuser->num_rows()>0){
            $tesuser = $query_tesuser->row();
            $query_komposisi = $this->cbt_tes_user_model->get_komposisi_soal_by_tesuser($tesuser->tesuser_id);

            if($query_komposisi->num_rows()>0){
                $komposisi = $query_komposisi->row();
                $nilai_maksimal = $this->hitung_nilai_maksimal_essay(
                    intval($komposisi->total_essay),
                    intval($komposisi->total_objektif)
                );
            }
        }

        return $nilai_maksimal;
    }

    function simpan_nilai(){
        $this->load->library('form_validation');

        $this->form_validation->set_rules('evaluasi-testlog-id', 'Soal','required|strip_tags');
        $this->form_validation->set_rules('evaluasi-nilai', '','required|numeric|strip_tags');

        if($this->form_validation->run() == TRUE){
            $nilai = floatval($this->input->post('evaluasi-nilai', TRUE));
            $nilai_min = 0;
            $tessoal_id = $this->input->post('evaluasi-testlog-id', TRUE);
            $nilai_max = $this->get_nilai_maksimal_essay_by_tessoal($tessoal_id);

            if($nilai_max<=0){
                $status['status'] = 0;
                $status['pesan'] = 'Nilai maksimal essay belum bisa dihitung. Pastikan tes memiliki soal essay.';
            }else if($nilai>=$nilai_min AND $nilai<=$nilai_max){
                $data['tessoal_nilai'] = $nilai;
                $data['tessoal_comment'] = 'Sudah di koreksi '.$this->access->get_username();

                $this->cbt_tes_soal_model->update('tessoal_id', $tessoal_id, $data);

                $status['status'] = 1;
                $status['pesan'] = 'Nilai berhasil disimpan ';
            }else{
                $status['status'] = 0;
                $status['pesan'] = 'Nilai tidak boleh dibawah 0 dan di atas Nilai Maximal '.$nilai_max.' !';
            }
        }else{
            $status['status'] = 0;
            $status['pesan'] = validation_errors();
        }

        echo json_encode($status);
    }

    function export($tes_id=null, $urutkan=null){
        if(!empty($tes_id)){
            $this->load->library('excel');

            if(empty($urutkan)){
                $urutkan = 'soal';
            }

            $nilai_maksimal_essay = $this->get_nilai_maksimal_essay($tes_id);
            $query_soal = $this->cbt_tes_user_model->get_evaluasi_export_soal($tes_id, $urutkan);
            $query_peserta = $this->cbt_tes_user_model->get_evaluasi_export_peserta($tes_id, $urutkan);
            $excel = new PHPExcel();
            $worksheet = $excel->getActiveSheet();
            $worksheet->setTitle('Evaluasi Essay');

            $soal_essay = array();
            if($query_soal->num_rows()>0){
                $nomor = 1;
                foreach($query_soal->result() as $soal){
                    $soal_detail = str_replace("[base_url]", base_url(), $soal->soal_detail);
                    $soal_detail = html_entity_decode(strip_tags($soal_detail), ENT_QUOTES, 'UTF-8');
                    $soal_essay[] = array(
                        'id' => $soal->soal_id,
                        'nomor' => $nomor++,
                        'detail' => $soal_detail
                    );
                }
            }

            $peserta = array();
            $nama_tes = '';
            if($query_peserta->num_rows()>0){
                foreach($query_peserta->result() as $temp){
                    $nama_tes = $temp->tes_nama;
                    if(!isset($peserta[$temp->tesuser_id])){
                        $peserta[$temp->tesuser_id] = array(
                            'tesuser_id' => $temp->tesuser_id,
                            'nama' => stripslashes($temp->user_firstname),
                            'nilai' => array()
                        );
                    }
                    $peserta[$temp->tesuser_id]['nilai'][$temp->soal_id] = $temp->tessoal_nilai;
                }
            }

            $worksheet->setCellValueByColumnAndRow(0, 1, 'Nama TEST');
            $worksheet->setCellValueByColumnAndRow(1, 1, $nama_tes);
            $worksheet->getStyle('A1:B1')->getFont()->setBold(true);

            $worksheet->setCellValueByColumnAndRow(0, 3, 'List Soal Essay');
            $worksheet->getStyle('A3')->getFont()->setBold(true);

            $row = 4;
            foreach($soal_essay as $soal){
                $worksheet->setCellValueByColumnAndRow(0, $row, $soal['nomor'].'.');
                $worksheet->setCellValueByColumnAndRow(1, $row, $soal['detail']);
                $row++;
            }

            $row = $row+1;
            $soal_header_row = $row;
            $soal_id_row = $row+1;
            $header_row = $row+2;
            $question_start_column = 5;
            $question_end_column = $question_start_column+count($soal_essay)-1;
            $poin_max_total_column = $question_start_column+count($soal_essay);
            $total_column = $poin_max_total_column+1;
            $last_question_column = PHPExcel_Cell::stringFromColumnIndex(max($question_start_column, $question_end_column));

            if(count($soal_essay)>0){
                $first_question_column = PHPExcel_Cell::stringFromColumnIndex($question_start_column);
                $worksheet->mergeCells($first_question_column.$soal_header_row.':'.$last_question_column.$soal_header_row);
                $worksheet->setCellValueByColumnAndRow($question_start_column, $soal_header_row, 'Soal');
                $worksheet->getStyle($first_question_column.$soal_header_row.':'.$last_question_column.$soal_header_row)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
                $worksheet->getStyle($first_question_column.$soal_header_row.':'.$last_question_column.$soal_header_row)->getFont()->setBold(true);
            }

            $worksheet->setCellValueByColumnAndRow($question_start_column-1, $soal_id_row, 'Soal ID');
            foreach($soal_essay as $index => $soal){
                $worksheet->setCellValueByColumnAndRow($question_start_column+$index, $soal_id_row, $soal['id']);
            }
            $worksheet->getStyle('A'.$soal_id_row.':'.$last_question_column.$soal_id_row)->getFont()->setBold(true);

            $worksheet->setCellValueByColumnAndRow(0, $header_row, 'No.');
            $worksheet->setCellValueByColumnAndRow(1, $header_row, 'Tes User ID');
            $worksheet->setCellValueByColumnAndRow(2, $header_row, 'Nama');
            $worksheet->setCellValueByColumnAndRow(3, $header_row, 'Poin Min');
            $worksheet->setCellValueByColumnAndRow(4, $header_row, 'Poin Max');

            foreach($soal_essay as $index => $soal){
                $worksheet->setCellValueByColumnAndRow($question_start_column+$index, $header_row, $soal['nomor']);
            }
            $worksheet->setCellValueByColumnAndRow($poin_max_total_column, $header_row, 'Poin Max Total');
            $worksheet->setCellValueByColumnAndRow($total_column, $header_row, 'Total');

            $last_header_column = PHPExcel_Cell::stringFromColumnIndex($total_column);
            $worksheet->getStyle('A'.$header_row.':'.$last_header_column.$header_row)->getFont()->setBold(true);

            $row = $header_row+1;
            $nomor = 1;
            $nilai_maksimal_total = $nilai_maksimal_essay*count($soal_essay);
            foreach($peserta as $data_peserta){
                $worksheet->setCellValueByColumnAndRow(0, $row, $nomor++);
                $worksheet->setCellValueByColumnAndRow(1, $row, $data_peserta['tesuser_id']);
                $worksheet->setCellValueByColumnAndRow(2, $row, $data_peserta['nama']);
                $worksheet->setCellValueByColumnAndRow(3, $row, 0);
                $worksheet->setCellValueByColumnAndRow(4, $row, $nilai_maksimal_essay);

                foreach($soal_essay as $index => $soal){
                    $nilai = '';
                    if(isset($data_peserta['nilai'][$soal['id']])){
                        $nilai = $data_peserta['nilai'][$soal['id']];
                    }
                    $worksheet->setCellValueByColumnAndRow($question_start_column+$index, $row, $nilai);
                }

                if(count($soal_essay)>0){
                    $first_question_column = PHPExcel_Cell::stringFromColumnIndex($question_start_column);
                    $last_question_column = PHPExcel_Cell::stringFromColumnIndex($question_end_column);
                    $worksheet->setCellValueByColumnAndRow($poin_max_total_column, $row, $nilai_maksimal_total);
                    $worksheet->setCellValueByColumnAndRow($total_column, $row, '=SUM('.$first_question_column.$row.':'.$last_question_column.$row.')');
                }else{
                    $worksheet->setCellValueByColumnAndRow($poin_max_total_column, $row, 0);
                    $worksheet->setCellValueByColumnAndRow($total_column, $row, 0);
                }
                $row++;
            }

            $worksheet->getStyle('A:'.$last_header_column)->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_TOP);
            $worksheet->getStyle('C')->getAlignment()->setWrapText(true);
            $worksheet->getColumnDimension('A')->setWidth(8);
            $worksheet->getColumnDimension('B')->setWidth(14);
            $worksheet->getColumnDimension('C')->setWidth(35);
            $worksheet->getColumnDimension('D')->setWidth(12);
            $worksheet->getColumnDimension('E')->setWidth(12);
            for($kolom = $question_start_column; $kolom <= $question_end_column; $kolom++){
                $worksheet->getColumnDimension(PHPExcel_Cell::stringFromColumnIndex($kolom))->setWidth(10);
            }
            $worksheet->getColumnDimension(PHPExcel_Cell::stringFromColumnIndex($poin_max_total_column))->setWidth(16);
            $worksheet->getColumnDimension(PHPExcel_Cell::stringFromColumnIndex($total_column))->setWidth(12);

            $filename='Data Evaluasi Essay - '.date('Y-m-d H:i').'.xlsx';
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="'.$filename.'"');
            header('Cache-Control: max-age=0');

            $objWriter = PHPExcel_IOFactory::createWriter($excel, 'Excel2007');
            $objWriter->save('php://output');
        }
    }

    function import_nilai(){
        $status['status'] = 0;
        $status['pesan'] = 'Import nilai gagal';

        $tes_id = $this->input->post('tes-id', true);
        if(empty($tes_id)){
            $status['pesan'] = 'Pilih tes terlebih dahulu';
            echo json_encode($status);
            return;
        }

        if(empty($_FILES['userfile']['name'])){
            $status['pesan'] = 'Pilih file Excel hasil export terlebih dahulu';
            echo json_encode($status);
            return;
        }

        $config['upload_path'] = './public/uploads/';
        $config['allowed_types'] = 'xlsx';
        $config['max_size'] = '0';
        $config['overwrite'] = true;
        $config['file_name'] = 'import-nilai-evaluasi-'.$tes_id.'-'.date('YmdHis').'.xlsx';

        $this->load->library('upload', $config);
        if (!$this->upload->do_upload()){
            $status['pesan'] = $this->upload->display_errors().'Tipe file yang di upload adalah '.$_FILES['userfile']['type'];
            echo json_encode($status);
            return;
        }

        $upload_data = $this->upload->data();
        $hasil = $this->import_file_nilai($tes_id, $upload_data['file_name']);
        echo json_encode($hasil);
    }

    private function import_file_nilai($tes_id, $inputfile){
        $this->load->library('excel');

        $status['status'] = 0;
        $status['pesan'] = 'Format file import tidak sesuai';
        $inputFileName = './public/uploads/'.$inputfile;
        $excel = PHPExcel_IOFactory::load($inputFileName);
        $worksheet = $excel->getSheet(0);
        $highestRow = $worksheet->getHighestRow();
        $highestColumnIndex = PHPExcel_Cell::columnIndexFromString($worksheet->getHighestColumn());

        $header_row = 0;
        for($row=1; $row<=$highestRow; $row++){
            $kolom_no = trim($worksheet->getCellByColumnAndRow(0, $row)->getValue());
            if($kolom_no=='No.'){
                $header_row = $row;
                break;
            }
        }

        if($header_row==0){
            return $status;
        }

        $soal_id_row = $header_row-1;
        $tesuser_column = -1;
        $poin_max_column = -1;
        $poin_max_total_column = -1;

        for($kolom=0; $kolom<$highestColumnIndex; $kolom++){
            $header = trim($worksheet->getCellByColumnAndRow($kolom, $header_row)->getValue());
            if($header=='Tes User ID'){
                $tesuser_column = $kolom;
            }else if($header=='Poin Max'){
                $poin_max_column = $kolom;
            }else if($header=='Poin Max Total'){
                $poin_max_total_column = $kolom;
            }
        }

        if($tesuser_column<0 OR $poin_max_column<0 OR $poin_max_total_column<0){
            return $status;
        }

        $question_start_column = $poin_max_column+1;
        $question_end_column = $poin_max_total_column-1;
        $jmldatasukses = 0;
        $jmldataerror = 0;
        $pesan_error = '';
        $nilai_max_peserta = array();

        $this->db->trans_start();
        for($row=$header_row+1; $row<=$highestRow; $row++){
            $tesuser_id = intval($worksheet->getCellByColumnAndRow($tesuser_column, $row)->getValue());
            if($tesuser_id<=0){
                continue;
            }

            if(!isset($nilai_max_peserta[$tesuser_id])){
                $nilai_max_peserta[$tesuser_id] = $this->get_nilai_maksimal_essay_by_tessoal_id_tesuser($tesuser_id);
            }
            $nilai_max = $nilai_max_peserta[$tesuser_id];
            if($nilai_max<=0){
                $jmldataerror++;
                $pesan_error .= 'Baris '.$row.' nilai maksimal essay tidak bisa dihitung<br>';
                continue;
            }

            for($kolom=$question_start_column; $kolom<=$question_end_column; $kolom++){
                $soal_id = intval($worksheet->getCellByColumnAndRow($kolom, $soal_id_row)->getValue());
                $nilai_cell = $worksheet->getCellByColumnAndRow($kolom, $row)->getCalculatedValue();

                if($soal_id<=0 OR $nilai_cell==='' OR $nilai_cell===null){
                    continue;
                }

                if(!is_numeric($nilai_cell)){
                    $jmldataerror++;
                    $pesan_error .= 'Baris '.$row.' kolom '.PHPExcel_Cell::stringFromColumnIndex($kolom).' bukan angka<br>';
                    continue;
                }

                $nilai = floatval($nilai_cell);
                if($nilai<0 OR $nilai>$nilai_max){
                    $jmldataerror++;
                    $pesan_error .= 'Baris '.$row.' kolom '.PHPExcel_Cell::stringFromColumnIndex($kolom).' di luar batas 0 - '.$nilai_max.'<br>';
                    continue;
                }

                $affected = $this->cbt_tes_soal_model->update_nilai_essay_import($tes_id, $tesuser_id, $soal_id, $nilai, $this->access->get_username());
                if($affected>=0){
                    $jmldatasukses++;
                }else{
                    $jmldataerror++;
                }
            }
        }
        $this->db->trans_complete();

        if($jmldatasukses>0 AND $jmldataerror==0){
            $status['status'] = 1;
        }else if($jmldatasukses>0){
            $status['status'] = 1;
        }

        $status['pesan'] = 'Import selesai. Nilai berhasil diproses: '.$jmldatasukses.'. Error: '.$jmldataerror;
        if(!empty($pesan_error)){
            $status['pesan'] .= '<br>'.$pesan_error;
        }

        return $status;
    }

    private function get_nilai_maksimal_essay_by_tessoal_id_tesuser($tesuser_id){
        $nilai_maksimal = 0;
        $query_komposisi = $this->cbt_tes_user_model->get_komposisi_soal_by_tesuser($tesuser_id);

        if($query_komposisi->num_rows()>0){
            $komposisi = $query_komposisi->row();
            $nilai_maksimal = $this->hitung_nilai_maksimal_essay(
                intval($komposisi->total_essay),
                intval($komposisi->total_objektif)
            );
        }

        return $nilai_maksimal;
    }

    /**
     * Mendapatkan soal dan jawaban berdasarkan tessoal_id
     *
     * @param      <type>  $id     The identifier
     */
    function get_by_id($id=null){
    	$data['data'] = 0;
		if(!empty($id)){
			$query = $this->cbt_modul_model->get_by_kolom('modul_id', $id);
			if($query->num_rows()>0){
				$query = $query->row();
				$data['data'] = 1;
				$data['id'] = $query->modul_id;
				$data['modul'] = $query->modul_nama;
				$data['status'] = $query->modul_aktif;
			}
		}
		echo json_encode($data);
    }
    
	function get_datatable(){
		// variable initialization
		$tes_id = $this->input->get('tes');
		$urutkan = $this->input->get('urutkan');

		$search = "";
		$start = 0;
		$rows = 10;

		// get search value (if any)
		if (isset($_GET['sSearch']) && $_GET['sSearch'] != "" ) {
			$search = $_GET['sSearch'];
		}

		// limit
		$start = $this->get_start();
		$rows = $this->get_rows();

		// run query to get user listing
		$query = $this->cbt_tes_user_model->get_datatable_evaluasi($start, $rows, $tes_id, $urutkan);
		$iFilteredTotal = $query->num_rows();
		
		$iTotal= $this->cbt_tes_user_model->get_datatable_evaluasi_count($tes_id, $urutkan)->row()->hasil;
	    
		$output = array(
			"sEcho" => intval($_GET['sEcho']),
	        "iTotalRecords" => $iTotal,
	        "iTotalDisplayRecords" => $iTotal,
	        "aaData" => array()
	    );

	    // get result after running query and put it in array
		$i=$start;
		$query = $query->result();
	    foreach ($query as $temp) {			
			$record = array();

            $soal = $temp->soal_detail;
            $soal = str_replace("[base_url]", base_url(), $soal);
            
			$record[] = ++$i;
            $record[] = stripslashes($temp->user_firstname).' ('.$temp->user_name.')';
            $record[] = $soal;
			// $record[] = '<div style="width:600px;"><pre style="white-space: pre-wrap;word-wrap: break-word;">'.$temp->tessoal_jawaban_text.'</pre></div>';

			$jawaban = $temp->tessoal_jawaban_text;
			// Menambah tag br untuk baris baru
			$jawaban = str_replace("\r","<br />",$jawaban);
			$jawaban = str_replace("\n","<br />",$jawaban);
			
			$record[] = $jawaban;

            $nilai_maksimal_essay = $this->get_nilai_maksimal_essay_by_tessoal($temp->tessoal_id);

            $record[] = '<a onclick="evaluasi(\''.$temp->tessoal_id.'\',\'0\',\''.$nilai_maksimal_essay.'\')" style="cursor: pointer;" class="btn btn-default btn-xs">Evaluasi</a>';
            

			$output['aaData'][] = $record;
		}
		// format it to JSON, this output will be displayed in datatable
        
		echo json_encode($output);
	}
	
	/**
	* funsi tambahan 
	* 
	* 
*/
	
	function get_start() {
		$start = 0;
		if (isset($_GET['iDisplayStart'])) {
			$start = intval($_GET['iDisplayStart']);

			if ($start < 0)
				$start = 0;
		}

		return $start;
	}

	function get_rows() {
		$rows = 10;
		if (isset($_GET['iDisplayLength'])) {
			$rows = intval($_GET['iDisplayLength']);
			if ($rows < 5 || $rows > 500) {
				$rows = 10;
			}
		}

		return $rows;
	}

	function get_sort_dir() {
		$sort_dir = "ASC";
		$sdir = strip_tags($_GET['sSortDir_0']);
		if (isset($sdir)) {
			if ($sdir != "asc" ) {
				$sort_dir = "DESC";
			}
		}

		return $sort_dir;
	}
}
