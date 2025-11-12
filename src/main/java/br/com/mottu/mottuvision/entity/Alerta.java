package br.com.mottu.mottuvision.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
public class Alerta {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    private AlertaTipo tipo;

    private String mensagem;

    private LocalDateTime dataHora;

    @ManyToOne
    private Moto moto;

    public Alerta() { }

    public Alerta(AlertaTipo tipo, String mensagem, Moto moto) {
        this.tipo = tipo;
        this.mensagem = mensagem;
        this.moto = moto;
        this.dataHora = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public AlertaTipo getTipo() {
        return tipo;
    }

    public void setTipo(AlertaTipo tipo) {
        this.tipo = tipo;
    }

    public String getMensagem() {
        return mensagem;
    }

    public void setMensagem(String mensagem) {
        this.mensagem = mensagem;
    }

    public LocalDateTime getDataHora() {
        return dataHora;
    }

    public void setDataHora(LocalDateTime dataHora) {
        this.dataHora = dataHora;
    }

    public Moto getMoto() {
        return moto;
    }

    public void setMoto(Moto moto) {
        this.moto = moto;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Alerta alerta = (Alerta) o;
        return Objects.equals(id, alerta.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
